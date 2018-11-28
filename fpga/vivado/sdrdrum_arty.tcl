set project_name "sdrdrum_arty"

set path_bd  ../bd
set path_ip  ../ip
set path_rtl ../rtl
set path_top ../top

create_project -force ${project_name} ./${project_name}
set_property -name "board_part" -value "digilentinc.com:arty-a7-35:part0:1.0" -objects [current_project]

add_files -fileset sources_1 ${path_bd}/channel/channel.bd
add_files -fileset sources_1 ${path_bd}/controller/controller.bd
add_files -fileset sources_1 ${path_bd}/generator/generator.bd

add_files -fileset sources_1 ${path_ip}/xlnx_clk_gen_pmod_eth/xlnx_clk_gen_pmod_eth.xci

add_files -fileset sources_1 ${path_rtl}/ad5545.v
add_files -fileset sources_1 ${path_rtl}/ad7980.v
add_files -fileset sources_1 ${path_rtl}/axis_phase_generator.v
add_files -fileset sources_1 ${path_rtl}/framer.v

add_files -fileset sources_1 ${path_top}/sdrdrum_arty.v
add_files -fileset constrs_1 ${path_top}/sdrdrum_arty.xdc

update_compile_order -fileset sources_1

generate_target all [get_files channel.bd]
generate_target all [get_files controller.bd]
generate_target all [get_files generator.bd]
generate_target all [get_files xlnx_clk_gen_pmod_eth.xci]
generate_target all [get_files xlnx_ethernetlite.xci]

file mkdir ./${project_name}/${project_name}.sdk
write_hwdef ./${project_name}/${project_name}.sdk/${project_name}.hdf
