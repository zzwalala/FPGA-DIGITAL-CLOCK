
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name demo2 -dir "F:/FPGAfiles/demo2/planAhead_run_1" -part xc3s100ecp132-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "F:/FPGAfiles/demo2/top_clock.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {F:/FPGAfiles/demo2} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "top_clock.ucf" [current_fileset -constrset]
add_files [list {top_clock.ucf}] -fileset [get_property constrset [current_run]]
link_design
