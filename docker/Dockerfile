########################################
# Builder stage: compile the workspace #
########################################
FROM ros:rolling AS builder

WORKDIR /workspace
COPY src ./src

RUN apt-get update \
    && rosdep update \
    && rosdep install --from-paths src --ignore-src -y \
    && rm -rf /var/lib/apt/lists/*

RUN . /opt/ros/${ROS_DISTRO}/setup.sh \
    && colcon build --merge-install

#####################################
# Runtime stage: minimal deploy image #
#####################################
FROM ros:rolling-ros-core

ARG ROS_DISTRO=rolling
ENV ROS_DISTRO=${ROS_DISTRO}

# Runtime deps for turtlesim's Qt6 GUI; trim this list if the deploy target is headless
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ros-${ROS_DISTRO}-rclcpp \
        ros-${ROS_DISTRO}-rclcpp-action \
        qt6-base-dev \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /workspace/install /opt/workspace/install

COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["ros2", "run", "turtlesim", "turtlesim_node"]
