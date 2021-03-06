
if { [info exists synopsys_program_name ] && ($synopsys_program_name == "icc2_shell") } {
    puts " Creating ICC2 MCMM "
    create_mode func
    create_corner slow
    create_scenario -mode func -corner slow -name func_slow
    current_scenario func_slow
    set_operating_conditions ss0p75v125c
    read_parasitic_tech -tlup $tlu_dir/saed32nm_1p9m_Cmax.tluplus -layermap $tlu_dir/saed32nm_tf_itf_tluplus.map -name Cmax
    read_parasitic_tech -tlup $tlu_dir/saed32nm_1p9m_Cmin.tluplus -layermap $tlu_dir/saed32nm_tf_itf_tluplus.map -name Cmin
    set_parasitic_parameters -early_spec Cmax -early_temperature 125
    set_parasitic_parameters -late_spec Cmax -late_temperature 125
    #set_parasitic_parameters -early_spec 1p9m_Cmax -early_temperature 125 -corner default
    #set_parasitic_parameters -late_spec 1p9m_Cmax -late_temperature 125 -corner default

    #set_scenario_status  default -active false
    set_scenario_status func_slow -active true -hold true -setup true
}


create_clock -name "clk" -period 5.0 -waveform {0.0 2.5} clk
set_clock_uncertainty -setup 0.07 clk
set_clock_uncertainty -hold 0.01 clk
set_clock_transition 0.1 clk
set_clock_latency 0.1 clk

set_input_delay -0.5 inpBus* -clock clk
set_input_delay -0.5 enable -clock clk
set_output_delay 0.0 outBus* -clock clk

set_max_fanout 0.02 [ get_ports "enable" ]

set_drive 0.0000001 [all_inputs ]
set_load 0.5 [all_outputs]

#group_path -name INTERNAL -from [all_clocks] -to [all_clocks ]
group_path -name INPUTS -from [ get_ports -filter "direction==in&&full_name!~*clk*" ]
group_path -name OUTPUTS -to [ get_ports -filter "direction==out" ]

#set_operating_condition ss0p75vn40c -library saed32lvt_ss0p75vn40c
#set_operating_condition ss0p75v125c -library saed32lvt_ss0p75v125c

