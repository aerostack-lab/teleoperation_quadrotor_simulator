#!/bin/bash

NUMID_DRONE=107
export AEROSTACK_PROJECT=${AEROSTACK_STACK}/projects/teleoperation_quadrotor_simulator

. ${AEROSTACK_STACK}/config/mission/setup.sh

#---------------------------------------------------------------------------------------------
# INTERNAL PROCESSES
#---------------------------------------------------------------------------------------------
gnome-terminal  \
`#---------------------------------------------------------------------------------------------` \
`# Quadrotor simulator                                                                         ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Quadrotor Simulator" --command "bash -c \"
roslaunch quadrotor_simulator_process quadrotor_simulator.launch --wait \
    robot_namespace:=drone$NUMID_DRONE \
    robot_config_path:=${AEROSTACK_PROJECT}/configs/drone$NUMID_DRONE \
    rviz_config_path:=${AEROSTACK_PROJECT}/configs/rviz_files;
exec bash\""  \
`#---------------------------------------------------------------------------------------------` \
`# Quadrotor Motion With PID Control                                                           ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Quadrotor Motion With PID Control" --command "bash -c \"
roslaunch quadrotor_motion_with_pid_control quadrotor_motion_with_pid_control.launch --wait \
    namespace:=drone$NUMID_DRONE \
    robot_config_path:=${AEROSTACK_PROJECT}/configs/drone$NUMID_DRONE \
    uav_mass:=0.7;
exec bash\""  &

sleep 6
rosservice call /drone$NUMID_DRONE/quadrotor_motion_with_pid_control/behavior_quadrotor_pid_motion_control/activate_behavior "timeout: 10000"

#---------------------------------------------------------------------------------------------
# USER INTERFACE PROCESSES
#---------------------------------------------------------------------------------------------
gnome-terminal  \
`#---------------------------------------------------------------------------------------------` \
`# alphanumeric_viewer                                                                         ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "alphanumeric_viewer"  --command "bash -c \"
roslaunch alphanumeric_viewer alphanumeric_viewer.launch --wait \
    drone_id_namespace:=drone$NUMID_DRONE;
exec bash\""  &
gnome-terminal  \
`#---------------------------------------------------------------------------------------------` \
`# keyboard_teleoperation_interface                                                            ` \
`#---------------------------------------------------------------------------------------------` \
--title "keyboard_teleoperation_with_pid_control"  --command "bash -c \"
roslaunch keyboard_teleoperation_with_pid_control keyboard_teleoperation_with_pid_control.launch --wait \
  drone_id_namespace:=drone$NUMID_DRONE;
exec bash\""  &
