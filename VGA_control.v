`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:38:25 04/19/2021 
// Design Name: 
// Module Name:    VGA_control 
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
module VGA_control(
    input clk,
    input reset, 
    output reg[9:0] x_pos,
    output reg[9:0] y_pos,
	 
    output reg h_sync,
    output reg v_sync,
    output reg[7:0] color_out,
	input [7:0] hour24,
	input [7:0] minute,
	input [7:0] alarm_hour,
	input [7:0] alarm_minute

    );
	 reg [19:0] clk_cont;
	reg [9:0] line_cnt;
	reg clk_25M;

	reg[3:0] number;
	reg[3:0] scale;
   reg[9:0] start_x_pos;
	reg[9:0] start_y_pos;
	always @( posedge clk ) begin
		clk_25M <= ~clk_25M;
	end

	// generate display signal
	always @( posedge clk_25M  ) begin
		
		
		if( reset == 0) begin 

			clk_cont <= 0;
			line_cnt <= 0;

			h_sync <= 1;
			v_sync <= 1;

		end
		else begin
			x_pos <= clk_cont - 144;
			y_pos <= line_cnt - 35;
			//
			if( clk_cont == 0 ) begin
				h_sync <= 0;
				clk_cont <= clk_cont + 1;
			end
			else if( clk_cont == 96 ) begin
				h_sync <= 1;
				clk_cont <= clk_cont + 1;
			end
			else if( clk_cont == 800 ) begin
				clk_cont <= 0;
				line_cnt <= line_cnt + 1;
			end
			else clk_cont <= clk_cont + 1;

			// 
			if( line_cnt == 0 ) begin	
				v_sync <= 0;
			end
			else if( line_cnt == 2 ) begin
				v_sync <= 1;
			end
			else if( line_cnt == 525 ) begin
				line_cnt <= 0;
				v_sync <= 0;
			end	
			
			if( x_pos >= 0 && x_pos < 640 && y_pos >= 0 && y_pos < 480 )
			 begin
			   // 
				color_out = 8'b11111111;
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////				
			   start_y_pos = 190;
				start_x_pos = 150;
				number = hour24[7:4]; //scale wenti
				scale = 6;
				case(number)
				0:
             begin
              if(y_pos >= start_y_pos && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos)) begin
                color_out = 8'b00000000;
              end

              else if(y_pos >= start_y_pos && y_pos <= start_y_pos+16*scale && x_pos == start_x_pos+10*scale - 1) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+16*scale) begin
                color_out = 8'b00000000;
              end			  
            end
				
            1: begin
              if(y_pos >= start_y_pos && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos + 10*scale - 1)) begin
                color_out = 8'b00000000;
              end
				  
            end

            2: begin
              if(y_pos >= start_y_pos + 8*scale && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos)) begin
                color_out = 8'b00000000;
              end

              else if(y_pos >= start_y_pos && y_pos <= start_y_pos+8*scale && x_pos == start_x_pos+10*scale - 1) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos) begin
                color_out = 8'b00000000;
              end
				  else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+8*scale) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+16*scale) begin
                color_out = 8'b00000000;
              end
			  
            end
				endcase

          
				
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////				
			   start_y_pos = 190;
				start_x_pos = 230;
				number = hour24[3:0]; //scale wenti
				scale = 6;
				case(number)
            0: begin
              if(y_pos >= start_y_pos && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos)) begin
                color_out = 8'b00000000;
              end

              else if(y_pos >= start_y_pos && y_pos <= start_y_pos+16*scale && x_pos == start_x_pos+10*scale - 1) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+16*scale) begin
                color_out = 8'b00000000;
              end
			  
            end
				
            1: begin
              if(y_pos >= start_y_pos && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos + 10*scale - 1)) begin
                color_out = 8'b00000000;
              end
			  
            end

            2: begin
              if(y_pos >= start_y_pos + 8*scale && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos)) begin
                color_out = 8'b00000000;
              end

              else if(y_pos >= start_y_pos && y_pos <= start_y_pos+8*scale && x_pos == start_x_pos+10*scale - 1) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos) begin
                color_out = 8'b00000000;
              end
				  else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+8*scale) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+16*scale) begin
                color_out = 8'b00000000;
              end
			  
            end

            3: begin
              if(y_pos >= start_y_pos  && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos+10*scale - 1)) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos) begin
                color_out = 8'b00000000;
              end
				  else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+8*scale) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+16*scale) begin
                color_out = 8'b00000000;
              end
			  
            end

            4: begin
              if(y_pos >= start_y_pos && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos +10*scale - 1)) begin
                color_out = 8'b00000000;
              end

              else if(y_pos >= start_y_pos && y_pos <= start_y_pos+8*scale && x_pos == start_x_pos) begin
                color_out = 8'b00000000;
              end
				  else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+8*scale) begin
                color_out = 8'b00000000;
              end
			  
            end

            5: begin
              if(y_pos >= start_y_pos && (y_pos <= (start_y_pos+8*scale)) && (x_pos == start_x_pos)) begin
                color_out = 8'b00000000;
              end

              else if(y_pos >= start_y_pos + 8*scale && y_pos <= start_y_pos+16*scale && x_pos == start_x_pos+10*scale - 1) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos) begin
                color_out = 8'b00000000;
              end
				  else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+8*scale) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+16*scale) begin
                color_out = 8'b00000000;
              end
				  
            end

            6: begin
              if(y_pos >= start_y_pos && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos)) begin
                color_out = 8'b00000000;
              end

              else if(y_pos >= start_y_pos + 8*scale && y_pos <= start_y_pos+16*scale && x_pos == start_x_pos+10*scale - 1) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos <= start_x_pos+10*scale - 1 && y_pos == start_y_pos) begin
                color_out = 8'b00000000;
              end
				  else if(x_pos >= start_x_pos && x_pos <= start_x_pos+10*scale - 1 && y_pos == start_y_pos+8*scale) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos <= start_x_pos+10*scale - 1 && y_pos == start_y_pos+16*scale) begin
                color_out = 8'b00000000;
              end
			  
            end

            7: begin
              if(y_pos >= start_y_pos && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos+10*scale - 1)) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos <= start_x_pos+10*scale - 1 && y_pos == start_y_pos) begin
                color_out = 8'b00000000;
              end
			  
            end

            8: begin
              if(y_pos >= start_y_pos && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos)) begin
                color_out = 8'b00000000;
              end

              else if(y_pos >= start_y_pos && y_pos <= start_y_pos+16*scale && x_pos == start_x_pos+10*scale - 1) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos <= start_x_pos+10*scale - 1 && y_pos == start_y_pos) begin
                color_out = 8'b00000000;
              end
				  else if(x_pos >= start_x_pos && x_pos <= start_x_pos+10*scale - 1 && y_pos == start_y_pos+8*scale) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos <= start_x_pos+10*scale - 1  && y_pos == start_y_pos+16*scale) begin
                color_out = 8'b00000000;
				  end
			  
            end

            9: begin
              if(y_pos >= start_y_pos && (y_pos <= (start_y_pos+8*scale)) && (x_pos == start_x_pos)) begin
                color_out = 8'b00000000;
              end

              else if(y_pos >= start_y_pos && y_pos <= start_y_pos+16*scale && x_pos == start_x_pos+10*scale - 1) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos <= start_x_pos+10*scale -1 && y_pos == start_y_pos) begin
                color_out = 8'b00000000;
              end
				  else if(x_pos >= start_x_pos && x_pos <= start_x_pos+10*scale - 1 && y_pos == start_y_pos+8*scale) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos <= start_x_pos+10*scale - 1 && y_pos == start_y_pos+16*scale) begin
                color_out = 8'b00000000;
				  end			  
            end
				endcase
				
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////				
			   start_y_pos = 190;
				start_x_pos = 330;
				number = minute[7:4]; //scale wenti
				scale = 6;
				case(number)
            0: begin
              if(y_pos >= start_y_pos && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos)) begin
                color_out = 8'b00000000;
              end

              else if(y_pos >= start_y_pos && y_pos <= start_y_pos+16*scale && x_pos == start_x_pos+10*scale - 1) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+16*scale) begin
                color_out = 8'b00000000;
              end
			  
            end
				
            1: begin
              if(y_pos >= start_y_pos && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos + 10*scale - 1)) begin
                color_out = 8'b00000000;
              end
			  
            end

            2: begin
              if(y_pos >= start_y_pos + 8*scale && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos)) begin
                color_out = 8'b00000000;
              end

              else if(y_pos >= start_y_pos && y_pos <= start_y_pos+8*scale && x_pos == start_x_pos+10*scale - 1) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos) begin
                color_out = 8'b00000000;
              end
				  else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+8*scale) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+16*scale) begin
                color_out = 8'b00000000;
              end
			  
            end

            3: begin
              if(y_pos >= start_y_pos  && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos+10*scale - 1)) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos) begin
                color_out = 8'b00000000;
              end
				  else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+8*scale) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+16*scale) begin
                color_out = 8'b00000000;
              end
			  
            end

            4: begin
              if(y_pos >= start_y_pos && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos +10*scale - 1)) begin
                color_out = 8'b00000000;
              end

              else if(y_pos >= start_y_pos && y_pos <= start_y_pos+8*scale && x_pos == start_x_pos) begin
                color_out = 8'b00000000;
              end
				  else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+8*scale) begin
                color_out = 8'b00000000;
              end
			  
            end

            5: begin
              if(y_pos >= start_y_pos && (y_pos <= (start_y_pos+8*scale)) && (x_pos == start_x_pos)) begin
                color_out = 8'b00000000;
              end

              else if(y_pos >= start_y_pos + 8*scale && y_pos <= start_y_pos+16*scale && x_pos == start_x_pos+10*scale - 1) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos) begin
                color_out = 8'b00000000;
              end
				  else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+8*scale) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+16*scale) begin
                color_out = 8'b00000000;
              end
				  
            end
				endcase

            
				
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////				
			   start_y_pos = 190;
				start_x_pos = 410;
				number = minute[3:0]; //scale wenti
				scale = 6;
				case(number)
            0: begin
              if(y_pos >= start_y_pos && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos)) begin
                color_out = 8'b00000000;
              end

              else if(y_pos >= start_y_pos && y_pos <= start_y_pos+16*scale && x_pos == start_x_pos+10*scale - 1) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+16*scale) begin
                color_out = 8'b00000000;
              end
			  
            end
				
            1: begin
              if(y_pos >= start_y_pos && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos + 10*scale - 1)) begin
                color_out = 8'b00000000;
              end
			  
            end

            2: begin
              if(y_pos >= start_y_pos + 8*scale && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos)) begin
                color_out = 8'b00000000;
              end

              else if(y_pos >= start_y_pos && y_pos <= start_y_pos+8*scale && x_pos == start_x_pos+10*scale - 1) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos) begin
                color_out = 8'b00000000;
              end
				  else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+8*scale) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+16*scale) begin
                color_out = 8'b00000000;
              end
			  
            end

            3: begin
              if(y_pos >= start_y_pos  && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos+10*scale - 1)) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos) begin
                color_out = 8'b00000000;
              end
				  else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+8*scale) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+16*scale) begin
                color_out = 8'b00000000;
              end
			  
            end

            4: begin
              if(y_pos >= start_y_pos && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos +10*scale - 1)) begin
                color_out = 8'b00000000;
              end

              else if(y_pos >= start_y_pos && y_pos <= start_y_pos+8*scale && x_pos == start_x_pos) begin
                color_out = 8'b00000000;
              end
				  else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+8*scale) begin
                color_out = 8'b00000000;
              end
			  
            end

            5: begin
              if(y_pos >= start_y_pos && (y_pos <= (start_y_pos+8*scale)) && (x_pos == start_x_pos)) begin
                color_out = 8'b00000000;
              end

              else if(y_pos >= start_y_pos + 8*scale && y_pos <= start_y_pos+16*scale && x_pos == start_x_pos+10*scale - 1) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos) begin
                color_out = 8'b00000000;
              end
				  else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+8*scale) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos < start_x_pos+10*scale && y_pos == start_y_pos+16*scale) begin
                color_out = 8'b00000000;
              end
				  
            end

            6: begin
              if(y_pos >= start_y_pos && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos)) begin
                color_out = 8'b00000000;
              end

              else if(y_pos >= start_y_pos + 8*scale && y_pos <= start_y_pos+16*scale && x_pos == start_x_pos+10*scale - 1) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos <= start_x_pos+10*scale - 1 && y_pos == start_y_pos) begin
                color_out = 8'b00000000;
              end
				  else if(x_pos >= start_x_pos && x_pos <= start_x_pos+10*scale - 1 && y_pos == start_y_pos+8*scale) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos <= start_x_pos+10*scale - 1 && y_pos == start_y_pos+16*scale) begin
                color_out = 8'b00000000;
              end
			  
            end

            7: begin
              if(y_pos >= start_y_pos && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos+10*scale - 1)) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos <= start_x_pos+10*scale - 1 && y_pos == start_y_pos) begin
                color_out = 8'b00000000;
              end
			  
            end

            8:begin
              if(y_pos >= start_y_pos && (y_pos <= (start_y_pos+16*scale)) && (x_pos == start_x_pos)) begin
                color_out = 8'b00000000;
              end

              else if(y_pos >= start_y_pos && y_pos <= start_y_pos+16*scale && x_pos == start_x_pos+10*scale - 1) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos <= start_x_pos+10*scale - 1 && y_pos == start_y_pos) begin
                color_out = 8'b00000000;
              end
				  else if(x_pos >= start_x_pos && x_pos <= start_x_pos+10*scale - 1 && y_pos == start_y_pos+8*scale) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos <= start_x_pos+10*scale - 1  && y_pos == start_y_pos+16*scale) begin
                color_out = 8'b00000000;
				  end
			  
            end

            9: begin
              if(y_pos >= start_y_pos && (y_pos <= (start_y_pos+8*scale)) && (x_pos == start_x_pos)) begin
                color_out = 8'b00000000;
              end

              else if(y_pos >= start_y_pos && y_pos <= start_y_pos+16*scale && x_pos == start_x_pos+10*scale - 1) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos <= start_x_pos+10*scale -1 && y_pos == start_y_pos) begin
                color_out = 8'b00000000;
              end
				  else if(x_pos >= start_x_pos && x_pos <= start_x_pos+10*scale - 1 && y_pos == start_y_pos+8*scale) begin
                color_out = 8'b00000000;
              end
              else if(x_pos >= start_x_pos && x_pos <= start_x_pos+10*scale - 1 && y_pos == start_y_pos+16*scale) begin
                color_out = 8'b00000000;
				  end			  
            end
				endcase


				
			  if(x_pos >= 307 && y_pos >= 213 && x_pos <= 313 && y_pos <= 217) 
				  begin
				    color_out = 8'b00000000;
				  end

			 
			 
			 if(x_pos >= 307 && y_pos >= 263 && x_pos <= 313 && y_pos <= 267) 
				  begin
				    color_out = 8'b00000000;
				  end
			end
			else 
				color_out = 8'b00000000;
		end
	end	  
endmodule
