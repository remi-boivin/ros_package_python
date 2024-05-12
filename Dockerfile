FROM ros:iron
ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=$USER_UID
# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=iron

# Create the user
RUN apt-get update && apt upgrade -y \
&& apt-get install -y lcov gcovr python3-pip python3.10-venv

RUN python3 -m venv env && \
    . ./env/bin/activate && \
    pip install pytest

ENV SHELL /bin/bash

WORKDIR /ros2_ws

# COPY ./scripts/ /ros2_ws/scripts
COPY . /ros2_ws/ros_package_python

WORKDIR /ros2_ws
RUN . /opt/ros/iron/setup.sh && colcon build --cmake-args -DENABLE_COVERAGE_TESTING=ON 

# Setup environment variables to source workspace setup.sh
RUN echo "source /ros2_ws/install/setup.bash" >> /root/.bashrc
# RUN echo "LD_LIBRARY_PATH=/lib:/opt/ros/iron/lib:/usr/local/lib:./build/cpp_pubsub" >> /root/.bashrc