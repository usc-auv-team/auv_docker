FROM ros:noetic-ros-core-focal

# Install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    python3-rosdep \
    python3-rosinstall \
    python3-vcstools \
    iproute2 \
    && rm -rf /var/lib/apt/lists/*

# Bootstrap rosdep
RUN rosdep init && \
  rosdep update --rosdistro $ROS_DISTRO

# Install ros packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-noetic-ros-base=1.5.0-1* \
    ros-noetic-rosbridge-suite \
    ros-noetic-catkin \
    && rm -rf /var/lib/apt/lists/*

# Install git
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

# Create ros workspace folders
RUN mkdir -p ~/catkin_ws/src && \
    cd ~/catkin_ws/src

# Add AUV ros drivers
RUN /bin/bash -c "cd ~/catkin_ws/src &&  \
    git clone https://github.com/USCAUV-Embedded-Systems/uscauv-ros-drivers.git && \
    cd uscauv-ros-drivers && \
    rm -rf auxpod/"

# Setup ROS and create catkin workspace
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && \
    cd ~/catkin_ws/ && \
    catkin_make"

# Replace entrypoint
COPY ./ros_entrypoint.sh /

EXPOSE 9090 11311

# Launch rosbridge
CMD ["roslaunch", "rosbridge_server", "rosbridge_websocket.launch"]