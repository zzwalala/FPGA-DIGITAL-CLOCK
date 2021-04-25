`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:25:54 03/24/2021 
// Design Name: 
// Module Name:    demo2 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
//**********************************
module top_clock(clk_50M,minH_change,minL_change,hour_change,mode_choose,alarm_flag,alarm_change_falg,swadd_flag,hum_flag,tem_flag,swdec_flag,vga_flag,seg,segout,AN,alarm,amorpm,dht11,test,h_sync,v_sync,color_out);
	input clk_50M;				//50MHZB8
	input minH_change;			//BTN1
	input minL_change;			//BTN0
	input hour_change;			//BTN2
	input mode_choose;			//12/24BTN3
	input alarm_flag;			//sw0
	input alarm_change_falg;	//,sw1
	input swadd_flag;			//sw2
	input hum_flag;				//
	input tem_flag;				//
	input swdec_flag;			//
	input vga_flag;

	
	output [7:0] seg;			//
	output [7:0] segout;		//
	output [3:0] AN;			//
	output alarm;				//
	output amorpm;				//AM/PMLED
	inout dht11;				//
	output [7:0] test;
	output h_sync;
    output v_sync;
    output [7:0] color_out;
	
	wire clk_1,clk100;
	wire clk;											//1HZ;
	wire clk_100;										//100HZ
	wire [7:0] second,minute,hour12,hour24;				//1224
	wire [7:0] alarm_hour,alarm_minute;					//
	wire [15:0] BCD;									//BCD
	reg mode_flag;										//12/24
	wire [7:0] swadd_msecond,swadd_second,swadd_minute;	//
	wire clean_add,stop_add;							////
	wire clk_1M,clk1m;
	
	wire [3:0] hum_high1,hum_low1,hum_high2,hum_low2;	//
	wire [3:0] tem_high1,tem_low1,tem_high2,tem_low2;	//
	
	wire dec_clr,dec_stop;
	wire [7:0] swdec_msecond,swdec_second,swdec_minute;	//
	
	wire [9:0] x_pos;
    wire [9:0] y_pos;
	
	
	assign test[7:0]={hum_high1,hum_low1};
	
	//
	divide1MHz du0(clk_50M,clk1m);
	assign clk_1M=clk1m;					//1Mhz
	divide100Hz du1(clk_1M,clk100);
	assign clk_100=clk100;					//100hz
	divide1Hz du2(clk_100,clk_1);
	assign clk=clk_1;						//1hz
	
	//60s106
	clk_counter10 c1(clk,second[3:0]);
	clk_counter6 c2((second[3:0]==4'b1001)&&clk,second[7:4]);
	
	//60min106
	clk_counter10 c3(((minL_change&&(!(alarm_change_falg||swadd_flag||swdec_flag)))||(second[3:0]==4'b1001)&&(second[7:4]==4'b0101)&&clk),minute[3:0]);	//59,+1
	clk_counter6 c4(((minH_change&&(!(alarm_change_falg||swadd_flag||swdec_flag)))||(minute[3:0]==4'b1001)&&(second[7:4]==4'b0101)&&(second[3:0]==4'b1001)&&clk),minute[7:4]);	//959
		
		
	//1224
	always @(negedge mode_choose)
	begin
		mode_flag<=(~mode_flag);
	end
	
	
	//2424
	clk_counter24 c5(((hour_change&&(!(alarm_change_falg||swadd_flag||swdec_flag)))||(minute[7:4]==4'b0101)&&(minute[3:0]==4'b1001)&&(second[7:4]==4'b0101)&&(second[3:0]==4'b1001)&&clk),hour24[7:4],hour24[3:0]);		//5959+1
	//1212
	clk_counter12 c6(((hour_change&&(!(alarm_change_falg||swadd_flag||swdec_flag)))||(minute[7:4]==4'b0101)&&(minute[3:0]==4'b1001)&&(second[7:4]==4'b0101)&&(second[3:0]==4'b1001)&&clk),hour12[7:4],hour12[3:0]);		//5959+1
	
	
	//
	BCD_choosing d0(mode_flag,alarm_change_falg,alarm_hour,alarm_minute,hour24,hour12,minute,BCD,swadd_flag,swadd_minute,swadd_second,hum_flag,hum_high1,hum_low1,hum_high2,hum_low2,tem_flag,tem_high1,tem_low1,tem_high2,tem_low2,swdec_flag,swdec_second,swdec_minute);
	seg_choosing d1(seg,second,swadd_flag,swadd_msecond,swdec_flag,swdec_msecond);
	display d2(clk_50M,BCD,segout,AN);
	
	//AM/PMLED
	assign amorpm=(hour24[7:0]>17)?1:0;
	
	//
	clk_alarm a1(alarm_hour==hour24&&alarm_minute==minute&&clk,alarm_flag,alarm);
	
	//
	clk_counter10 a2(minL_change&&alarm_change_falg,alarm_minute[3:0]);
	clk_counter6 a3(minH_change&&alarm_change_falg,alarm_minute[7:4]);
	clk_counter24 a4(hour_change&&alarm_change_falg,alarm_hour[7:4],alarm_hour[3:0]);
	
	//
	clean_add_change stw0(swadd_flag&&minL_change,clean_add);
	stop_add_change stw1(swadd_flag&&minH_change,stop_add);			//stopclean
	
	stwadd_msecond_counter stw2(swadd_flag&&clk_100,clean_add,stop_add,swadd_msecond);
	stwadd_second_counter stw3(swadd_flag&&clk_100,clean_add,stop_add,swadd_msecond,swadd_second);
	stwadd_minute_counter stw4(swadd_flag&&clk_100,clean_add,stop_add,swadd_msecond,swadd_second,swadd_minute);
	
	//
	stop_add_change sd0(swdec_flag&&mode_choose,dec_stop);
	clean_add_change sd1(swdec_flag&&hour_change,dec_clr);
	
	dec_counter10 sd2(dec_stop&&swdec_flag&&clk_100,swdec_msecond[3:0],dec_clr);
	dec_counter10 sd3(dec_stop&&swdec_flag&&clk_100&&(swdec_msecond[3:0]==3'b0),swdec_msecond[7:4],dec_clr);
	dec_counter10 sd4((dec_stop&&swdec_flag&&clk_100&&(swdec_msecond[3:0]==3'b0)&&(swdec_msecond[7:4]==4'd0))||(swdec_flag&&minL_change),swdec_second[3:0],dec_clr);
	dec_counter6 sd5(dec_stop&&swdec_flag&&clk_100&&((swdec_msecond[3:0]==3'b0)&&(swdec_msecond[7:4]==4'd0)&&(swdec_second[3:0]==4'd0))||(swdec_flag&&minL_change&&swdec_second[3:0]==4'd0),swdec_second[7:4],dec_clr);
	dec_counter10 sd6((dec_stop&&swdec_flag&&clk_100&&(swdec_msecond[3:0]==3'b0)&&(swdec_msecond[7:4]==4'd0)&&(swdec_second[3:0]==4'd0)&&(swdec_second[7:4]==4'd0))||(swdec_flag&&minH_change),swdec_minute[3:0],dec_clr);
	dec_counter6 sd7((dec_stop&&swdec_flag&&clk_100&&(swdec_msecond[3:0]==3'b0)&&(swdec_msecond[7:4]==4'd0)&&(swdec_second[3:0]==4'd0)&&(swdec_second[7:4]==4'd0)&&(swdec_minute[3:0]==4'd0))||(swdec_flag&&minH_change&&swdec_minute[3:0]==4'd0),swdec_minute[7:4],dec_clr);
	
	
	//
	sensor s0(clk_50M,(hum_flag||tem_flag),dht11,hum_high1,hum_low1,hum_high2,hum_low2,tem_high1,tem_low1,tem_high2,tem_low2);				//30
	
	VGA_control v0(clk_50M,vga_flag,x_pos,y_pos,h_sync,v_sync,color_out,hour24,minute,alarm_hour,alarm_minute);

endmodule






//
//******************************************************************************************
module dec_counter10(CP,num,clr);
    input CP;
    output reg[3:0] num;
	input clr;

	always @(negedge CP) 
	begin
		if(clr==1)			num<=4'b0;
		else if(num==4'b0)     num<=4'b1001;        //9
		else                 num<=num-1'b1;       //+1                              
	end
endmodule


//****************************************************************************************
module dec_counter6(CP,num,clr);
    input CP;
    output reg[3:0] num;
	input clr;

	always @(negedge CP) 
	begin
		if(clr==1)				num<=3'b0;
		else if(num==4'b0)     num<=4'b0101;
		else                 num<=num-1'b1;       //1                                 
	end
endmodule



//*******************************************************************************************************
module sensor(clk,res,dht11,hum_high1,hum_low1,hum_high2,hum_low2,tem_high1,tem_low1,tem_high2,tem_low2);  
 
    input                clk  ;  //
    input                res  ;   //                                    
    inout                dht11  ;  //dht11
	output reg[3:0] hum_high1;
	output reg[3:0] hum_low1;
	output reg[3:0] hum_high2;
	output reg[3:0] hum_low2;
	output reg[3:0] tem_high1;
	output reg[3:0] tem_low1;
	output reg[3:0] tem_high2;
	output reg[3:0] tem_low2;
	
	integer i;
	
	reg  [31:0]  data_out;      //  
//parameter define 
parameter  POWER_ON_NUM     = 1000_000; //,us
//                     
parameter  st_power_on_wait = 3'd0;     // 000
parameter  st_low_500us      = 3'd1;     //500us 001
parameter  st_high_40us     = 3'd2;     //40us 010
parameter  st_rec_low_83us  = 3'd3;     //83us 011
parameter  st_rec_high_87us = 3'd4;     //87us100
parameter  st_rec_data      = 3'd5;     //40 101
parameter  st_delay         = 3'd6;     //,dht11 110

//reg define
reg    [2:0]   cur_state   ;        // 3
reg    [2:0]   next_state  ;        //
                                    
reg    [4:0]   clk_cnt     ;        //
reg            clk_1m      ;        //1Mhz
reg    [20:0]  us_cnt      ;        //1
reg            us_cnt_clr  ;        //1
                                    
reg    [39:0]  data_temp   ;        //
reg            step        ;        //
reg    [5:0]   data_cnt    ;        //

reg            dht11_buffer;        //dht11
reg            dht11_d0    ;        //dht110
reg            dht11_d1    ;        //dht111

//wire define                       
wire        dht11_pos      ;        //dht11
wire        dht11_neg      ;        //dht11

//*****************************************************
//**                    main code
//*****************************************************



//
	always @(data_out)
	begin
		hum_high1=4'b0;
		hum_low1=4'b0;
		for(i=7;i>=0;i=i-1)
		begin
			if(hum_high1>=4'd5)		hum_high1=hum_high1+4'd3;
			if(hum_low1>=4'd5)		hum_low1=hum_low1+4'd3;
			
			hum_high1=hum_high1<<1;
			hum_high1[0]=hum_low1[3];
			hum_low1=hum_low1<<1;
			hum_low1[0]=data_out[24+i];
		end
	end
	//
	always @(data_out)
	begin
		hum_high2=4'b0;
		hum_low2=4'b0;
		for(i=7;i>=0;i=i-1)
		begin
			if(hum_high2>=4'd5)	hum_high2=hum_high2+4'd3;
			if(hum_low2>=4'd5)		hum_low2=hum_low2+4'd3;
			
			hum_high2=hum_high2<<1;
			hum_high2[0]=hum_low2[3];
			hum_low2=hum_low2<<1;
			hum_low2[0]=data_out[16+i];
		end
	end
	//
	always @(data_out)
	begin
		tem_high1=4'b0;
		tem_low1=4'b0;
		for(i=7;i>=0;i=i-1)
		begin
			if(tem_high1>=4'd5)	tem_high1=tem_high1+4'd3;
			if(tem_low1>=4'd5)		tem_low1=tem_low1+4'd3;
			
			tem_high1=tem_high1<<1;
			tem_high1[0]=tem_low1[3];
			tem_low1=tem_low1<<1;
			tem_low1[0]=data_out[8+i];
		end
	end
	//
	always @(data_out)
	begin
		tem_high2=4'b0;
		tem_low2=4'b0;
		for(i=7;i>=0;i=i-1)
		begin
			if(tem_high2>=4'd5)	tem_high2=tem_high2+4'd3;
			if(tem_low2>=4'd5)	tem_low2=tem_low2+4'd3;
			
			tem_high2=tem_high2<<1;
			tem_high2[0]=tem_low2[3];
			tem_low2=tem_low2<<1;
			tem_low2[0]=data_out[i];
		end
	end

assign dht11     = dht11_buffer;
assign dht11_pos = (~dht11_d1) & dht11_d0; //
assign dht11_neg = dht11_d1 & (~dht11_d0); //

//1Mhz
always @ (posedge clk or negedge res) begin   //posedgenegedge
    if (!res) begin
        clk_cnt <= 5'd0;
        clk_1m  <= 1'b0;
    end 
    else if (clk_cnt < 5'd24) 
        clk_cnt <= clk_cnt + 1'b1;       
    else begin
        clk_cnt <= 5'd0;
        clk_1m  <= ~ clk_1m;
    end 
end

//dht11
always @ (posedge clk_1m or negedge res) begin
    if (!res) begin
        dht11_d0 <= 1'b1;
        dht11_d1 <= 1'b1;
    end 
    else begin
        dht11_d0 <= dht11;
        dht11_d1 <= dht11_d0;
    end 
end 

//1
always @ (posedge clk_1m or negedge res) begin
    if (!res)
        us_cnt <= 21'd0;
    else if (us_cnt_clr)
        us_cnt <= 21'd0;
    else 
        us_cnt <= us_cnt + 1'b1;
end 

//
always @ (posedge clk_1m or negedge res) begin
    if (!res)
        cur_state <= st_power_on_wait;
    else 
        cur_state <= next_state;
end 

//DHT11
always @ (posedge clk_1m or negedge res) begin
    if(!res) begin
        next_state   <= st_power_on_wait;
        data_temp    <= 40'd0;
        step         <= 1'b0; 
        us_cnt_clr   <= 1'b0;
        data_cnt     <= 6'd0;
        dht11_buffer <= 1'bz;   
    end 
    else begin
        case (cur_state)
                //1dht11
            st_power_on_wait : begin                
                if(us_cnt < POWER_ON_NUM) begin
                    dht11_buffer <= 1'bz; //
                    us_cnt_clr   <= 1'b0;
                end
                else begin            
                    next_state   <= st_low_500us;
                    us_cnt_clr   <= 1'b1;
                end
            end
                //FPGA500us    
            st_low_500us: begin
                if(us_cnt < 20_000) begin
                    dht11_buffer <= 1'b0; // 
                    us_cnt_clr   <= 1'b0;
                end
                else begin
                    dht11_buffer <= 1'bz; //
                    next_state   <= st_high_40us;
                    us_cnt_clr   <= 1'b1;
                end    
            end 
                //dht1120~40us
            st_high_40us:begin                      
                if (us_cnt < 40) begin
                    us_cnt_clr   <= 1'b0;
                    if(dht11_neg) begin   //dht11
                        next_state <= st_rec_low_83us;
                        us_cnt_clr <= 1'b1; 
                    end
                end
                else                      //40us
                    next_state <= st_delay;
            end 
                //dht1183us
            st_rec_low_83us: begin                  
                if(dht11_pos)                   
                    next_state <= st_rec_high_87us;  
            end 
                //dht1187usFPGA
            st_rec_high_87us: begin
                if(dht11_neg) begin       //    
                    next_state <= st_rec_data; 
                    us_cnt_clr <= 1'b1;
                end
                else begin                //
                    data_cnt  <= 6'd0;
                    data_temp <= 40'd0;
                    step  <= 1'b0;
                end
            end 
                //40 
            st_rec_data: begin                                
                case(step)
                    0: begin              //
                        if(dht11_pos) begin 
                            step   <= 1'b1;
                            us_cnt_clr <= 1'b1;
                        end            
                        else              //
                            us_cnt_clr <= 1'b0;
                    end
                    1: begin              //
                        if(dht11_neg) begin 
                            data_cnt <= data_cnt + 1'b1;
                                          //0/1
                            if(us_cnt < 40)
                                data_temp <= {data_temp[38:0],1'b0};
                            else                
                                data_temp <= {data_temp[38:0],1'b1};
                            step <= 1'b0;
                            us_cnt_clr <= 1'b1;
                        end 
                        else              //
                            us_cnt_clr <= 1'b0;
                    end
                endcase
                
                if(data_cnt == 40) begin  //
                    next_state <= st_delay;
                   // if(data_temp[7:0] == data_temp[39:32] + data_temp[31:24] 
                     //                    + data_temp[23:16] + data_temp[15:8])
                        data_out[31:0] <= data_temp[39:8];  
                end
            end 
                //2s
            st_delay:begin
                if(us_cnt < 2000_000)
                    us_cnt_clr <= 1'b0;
                else begin                //
                    next_state <= st_low_500us;      
                    us_cnt_clr <= 1'b1;
                end
            end
            default : ;
        endcase
    end 
end

endmodule 


//**************************************************************
module seg_choosing(seg,second,swadd_flag,swadd_msecond,swdec_flag,swdec_msecond);
	output reg [7:0] seg;
	input [7:0] second;		//
	input swadd_flag;		//
	input [7:0] swadd_msecond;	//
	input swdec_flag;
	input [7:0] swdec_msecond;
	
	always @(*)
	begin
		if(swadd_flag==1)
		begin
			seg[7:0]<=swadd_msecond[7:0];
		end
		else if(swdec_flag==1)
		begin
			seg[7:0]<=swdec_msecond[7:0];
		end
		else
		begin
			seg[7:0]<=second[7:0];
		end
	end
	
endmodule


//********************BCD***************************************************************************
module BCD_choosing(mode_flag,alarm_change_falg,alarm_hour,alarm_minute,hour24,hour12,minute,BCD,swadd_flag,swadd_minute,swadd_second,hum_flag,hum_high1,hum_low1,hum_high2,hum_low2,tem_flag,tem_high1,tem_low1,tem_high2,tem_low2,swdec_flag,swdec_second,swdec_minute);
	input mode_flag;			//12/24
	input alarm_change_falg;	//
	input [7:0]alarm_hour;		//
	input [7:0]alarm_minute;	//
	input [7:0]hour24;			//24
	input [7:0]hour12;			//12
	input [7:0]minute;			//
	output reg [15:0] BCD;
	input swadd_flag;			//
	input [7:0]swadd_minute;	//
	input [7:0]swadd_second;	//
	input hum_flag;
	input [3:0] hum_high1;
	input [3:0] hum_low1;
	input [3:0] hum_high2;
	input [3:0] hum_low2;
	input tem_flag;
	input [3:0] tem_high1;
	input [3:0] tem_low1;
	input [3:0] tem_high2;
	input [3:0] tem_low2;
	input swdec_flag;
	input [7:0] swdec_second;
	input [7:0] swdec_minute;
	
	always @(*)
	begin
		if(alarm_change_falg==1)
		begin
			BCD[15:0]<={alarm_hour,alarm_minute};
		end
		else if(swadd_flag==1)
		begin
			BCD[15:0]<={swadd_minute,swadd_second};
		end
		else if(tem_flag==1)
		begin
			BCD[15:0]<={tem_high1,tem_low1,tem_high2,tem_low2};
		end
		else if(hum_flag==1)
		begin
			BCD[15:0]<={hum_high1,hum_low1,8'b00000000};
		end
		else if(swdec_flag==1)
		begin
			BCD[15:0]<={swdec_minute,swdec_second};
		end
		else
		begin
			BCD[15:0]<=(mode_flag==1)?{hour24,minute}:{hour12,minute};
		end
	end

endmodule


//**********************/********************************************
module clean_add_change(cp,clean_add);
	input cp;
	output reg clean_add;
	
	always @(negedge cp)
	begin
		clean_add<=(~clean_add);
	end
endmodule


//**********************/***********************************************************
module stop_add_change(cp,stop_add);
	input cp;
	output reg stop_add;

	always @(negedge cp)
	begin
		stop_add<=(~stop_add);
	end
endmodule


//
//***************************************************************************************
module stwadd_msecond_counter(cp,clean,stop,msecond);
	input cp;
	input clean;		//
	input stop;			//
	output reg [7:0] msecond;	//bcd
	
	always @(negedge cp)
	begin
		if(clean==0)	//0
		begin
			msecond[7:0]<=0;
		end
		if(stop==0&&clean==1)
		begin
			if(msecond[3:0]==9)			//x9
			begin
				if(msecond[7:4]==9)		//99
				begin
					msecond[7:0]<=0;
				end
				else
				begin
					msecond[3:0]<=0;
					msecond[7:4]<=msecond[7:4]+1;
				end
			end
			else		//+1
			begin
				msecond[3:0]<=msecond[3:0]+1;
			end
		end
		
	end
	
endmodule


//***********************************************************************************
module stwadd_second_counter(cp,clean,stop,msecond,second);
	input cp;
	input clean;			//
	input stop;				//
	input [7:0] msecond;	//bcd
	output reg[7:0] second;	//bcd
	
	always @(negedge cp)
	begin
		if(clean==0)
		begin
			second[7:0]<=0;
		end
		if(stop==0&&clean==1)
		begin
			if(msecond[3:0]==9&&msecond[7:4]==9)	//99ms
			begin
				if(second[3:0]==9)			//x9
				begin
					if(second[7:4]==5)		//59
					begin
						second[7:0]<=0;
					end
					else
					begin
						second[3:0]<=0;
						second[7:4]<=second[7:4]+1;
					end
				end
				else
				begin
					second[3:0]<=second[3:0]+1;
				end
			end
		end
	end

endmodule


//*************************************************************************************
module stwadd_minute_counter(cp,clean,stop,msecond,second,minute);
	input cp;
	input clean;
	input stop;
	input [7:0] msecond;
	input [7:0] second;
	output reg [7:0] minute;
	
	always @(negedge cp)
	begin
		if(clean==0)
		begin
			minute[7:0]<=0;
		end
		if(clean==1&&stop==0)
		begin
			if(msecond[3:0]==9&&msecond[7:4]==9&&second[3:0]==9&&second[7:4]==5)	//59s 99ms
			begin
				if(minute[3:0]==9)			//x9
				begin
					if(minute[7:4]==5)		//59
					begin
						minute[7:0]<=0;
					end
					else
					begin
						minute[3:0]<=0;
						minute[7:4]<=minute[7:4]+1;
					end
				end
				else
				begin
					minute[3:0]<=minute[3:0]+1;
				end
			end
		end
	end
endmodule


//********************************************************************************
module clk_alarm(clk,flag,alarm);
	input clk;
	input flag;
	output reg alarm;
	
	reg [7:0] counter;

	
	always @(posedge clk)
	begin
		if(counter[7:0]>30)
		begin
			counter[7:0]<=8'b0;
			alarm<=0;
		end
		else
		begin
			counter[7:0]<=counter[7:0]+1;
		end
		alarm<=(flag==1&&(counter[7:0]%2==0))?1:0;
	end
endmodule


//******************************************************************************************
module clk_counter10(CP,num);
    input CP;
    output reg[3:0] num;

	always @(negedge CP) 
	begin
		if(num==4'b1001)     num<=4'b0000;        //9
		else                 num<=num+1'b1;       //+1                              
	end
endmodule


//****************************************************************************************
module clk_counter6(CP,num);
    input CP;
    output reg[3:0] num;

	always @(negedge CP) 
	begin
		if(num==4'b0101)     num<=4'b0000;
		else                 num<=num+1'b1;       //1                                 
	end
endmodule


//*******************24**************************************************************
module clk_counter24(cp,high,low);
	input cp;
	output reg[3:0] low;
	output reg[7:4] high;
	
	always @(negedge cp)
	begin
		if(high==0&&low<10)		//0~9
		begin
			if(low==9)
			begin
				low<=4'b0000;
				high<=4'b0001;
			end
			else	low<=low+1'b1;
		end
		else if(high==1&&low<10)	//10~19
		begin
			if(low==9)
				begin
				low<=4'b0000;
				high<=4'b0010;
				end
			else	low<=low+1'b1;
		end
		else if(high==2&&low<3)		//20~23
		begin
			low<=low+1'b1;
		end
		else						//
		begin
			{high,low}<=8'b0;
		end	
	end

endmodule


//*******************12********************************************************************
module clk_counter12(cp,high,low);
	input cp;
	output reg[3:0] low;
	output reg[7:4] high;
	
	always @(negedge cp)
	begin
		if(high==0&&low<10)		//0~9
		begin
			if(low==9)
			begin
				low<=4'b0000;
				high<=4'b0001;
			end
			else	low<=low+1'b1;
		end
		else if(high==1&&low<1)		//10~12
		begin
			low<=low+1'b1;
		end
		else						//
		begin
			{high,low}<=8'b0;
		end
	end

endmodule


//*********************************************************************************
module display(clk_50M,BCD,segout,AN);
	input clk_50M;
	input [15:0] BCD;
	output reg [7:0] segout;
	output reg [3:0] AN;
	
	wire S1,S0;
	wire [3:0] En;
	reg [3:0] InDigit;
	reg [19:0] Count;
	
	//
	always @(posedge clk_50M)
	begin
		Count<=Count+1;
	end
	
	assign {S1,S0}=Count[19:18];
	//T=20.9715msT/4=5.242875ms
	
	//41
	always @(*)
	begin
		case ({S1,S0})
			2'b00: InDigit=BCD[3:0];
			2'b01: InDigit=BCD[7:4];
			2'b10: InDigit=BCD[11:8];
			2'b11: InDigit=BCD[15:12];
		endcase
	end
	
	//
	always @(InDigit)
	case (InDigit)
		0: segout=8'b11000000;   //0,a,b,c,d,e,f,g
		1: segout=8'b11111001;   //1
		2: segout=8'b10100100;   //2
		3: segout=8'b10110000;   //3
		4: segout=8'b10011001;   //4
		5: segout=8'b10010010;   //5
		6: segout=8'b10000010;   //6
		7: segout=8'b11111000;   //7
		8: segout=8'b10000000;   //8
		9: segout=8'b10010000;   //9
		default: segout=8'b11111111;   //
	endcase
	
	//2-4
	assign En[3]=BCD[15]|BCD[14]|BCD[13]|BCD[12];  //0
	assign En[2]=1;  //0
	assign En[1]=|BCD[15:4];  //0
	assign En[0]=1;  //0
	
	always @(*)
	begin
		AN=4'b1111;
		if(En[{S1,S0}]==1)
			AN[{S1,S0}]=0;
	end
endmodule

//*******************50MHz1MHz******************
module divide1MHz(clk_50M,clk_1M);
	input clk_50M;			//50MHz
	output reg clk_1M;     //1MHz
	reg [4:0] num;                //
	
	always @(posedge clk_50M)
	begin
		if(num==5'b11000) 
        begin               
			num<=5'b0;           
			clk_1M<=(~clk_1M);
        end
		else 
        begin
			num<=num+1'b1;           //1
        end
	end 
endmodule

//*******************1MHz100Hz*****************************************************************
module divide100Hz(clk_1M,clk_100);
	input clk_1M;			//1MHz
	output reg clk_100;     //1Hz
	reg [12:0] num;                //
	
	always @(posedge clk_1M)
	begin
		if(num==13'b1001110000111) 
        begin               
			num<=13'd0;           
			clk_100<=(~clk_100);
        end
		else 
        begin
			num<=num+1'b1;           //1
        end
	end 
endmodule 



//*******************100Hz1Hz*****************************************************************
module divide1Hz(clk_100,clk_1);
	input clk_100;			//100Hz
	output reg clk_1;     //1Hz
	reg [5:0] num;                //
	
	always @(posedge clk_100)
	begin
		if(num==6'b110001) 
        begin              
			num<=6'd0;           
			clk_1<=(~clk_1);
        end
		else 
        begin
			num<=num+1'b1;           //1
        end
	end 
endmodule 