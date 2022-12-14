
# Set the name of the project:
set project_name ps_emio_eth_1g

# Set the project device:
set device xczu9eg-ffvb1156-2-e

# If using a UI layout, uncomment this line:
set ui_name layout.ui


# Set the path to the directory we want to put the Vivado build in. Convention is <PROJECT NAME>_hw
set proj_dir ../Hardware/${project_name}_hw


create_project -name ${project_name} -force -dir ${proj_dir} -part ${device}

# Source the BD file, BD naming convention is project_bd.tcl
source project_bd.tcl

#Set the path to the constraints file:
set impl_const ../Hardware/constraints/constraints.xdc

file mkdir ${proj_dir}/${project_name}.srcs/constrs_1/import
if [file exists ${impl_const}] {
    add_files -fileset constrs_1 -norecurse -copy_to ${proj_dir}/${project_name}.srcs/constrs_1/import ./${impl_const}
    set_property used_in_synthesis true [get_files -of [get_filesets constrs_1]]
}

make_wrapper -files [get_files ${proj_dir}/${project_name}.srcs/sources_1/bd/${project_name}/${project_name}.bd] -top

add_files -norecurse ${proj_dir}/${project_name}.srcs/sources_1/bd/${project_name}/hdl/${project_name}_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# If using UI, uncomment these three lines:
regenerate_bd_layout -layout_file ${ui_name}
file mkdir ${proj_dir}/${project_name}.srcs/sources_1/bd/${project_name}/ui
file copy -force ${ui_name} ${proj_dir}/${project_name}.srcs/sources_1/bd/${project_name}/ui/${ui_name}

validate_bd_design
save_bd_design
close_bd_design ${project_name}

open_bd_design ${proj_dir}/${project_name}.srcs/sources_1/bd/${project_name}/${project_name}.bd
set_property synth_checkpoint_mode None [get_files ${proj_dir}/${project_name}.srcs/sources_1/bd/${project_name}/${project_name}.bd]

