# auv_docker

A docker image that sets up ROS and ROSBridge!

## Usage
1. Build with `docker build -t auv/ros:1.0 .`
2. Start with `docker run -td --name ros_bridge -p 9090:9090 -p 11311:11311 auv/ros:1.0`
3. You can use Docker Hub to view details
