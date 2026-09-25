import math

import rclpy
from rclpy.executors import ExternalShutdownException
from rclpy.node import Node

from geometry_msgs.msg import Twist
from turtlesim_msgs.msg import Pose

# turtlesim's default window spans roughly [0, 11] on both axes
WALL_MARGIN = 1.0
WALL_MIN = WALL_MARGIN
WALL_MAX = 11.0 - WALL_MARGIN
TURN_ANGLE = math.pi / 2  # 90 degrees


class MinimalPublisher(Node):

    def __init__(self):
        super().__init__('minimal_publisher')
        self.publisher_ = self.create_publisher(Twist, 'turtle1/cmd_vel', 10)
        self.pose_subscriber = self.create_subscription(
            Pose, 'turtle1/pose', self.pose_callback, 10)
        timer_period = 0.1  # seconds
        self.timer = self.create_timer(timer_period, self.timer_callback)

        self.pose = None
        self.turning = False
        self.turn_start_theta = None

    def pose_callback(self, msg):
        self.pose = msg

    def hit_wall(self):
        return (self.pose.x <= WALL_MIN or self.pose.x >= WALL_MAX or
                self.pose.y <= WALL_MIN or self.pose.y >= WALL_MAX)

    def timer_callback(self):
        if self.pose is None:
            return

        msg = Twist()

        if self.turning:
            turned = abs(self.normalize_angle(self.pose.theta - self.turn_start_theta))
            if turned < TURN_ANGLE:
                msg.angular.z = 1.0
            else:
                self.turning = False
                msg.linear.x = 2.0
        elif self.hit_wall():
            self.turning = True
            self.turn_start_theta = self.pose.theta
            msg.angular.z = 1.0
        else:
            msg.linear.x = 2.0

        self.publisher_.publish(msg)

    @staticmethod
    def normalize_angle(angle):
        return math.atan2(math.sin(angle), math.cos(angle))


def main(args=None):
    try:
        with rclpy.init(args=args):
            minimal_publisher = MinimalPublisher()

            rclpy.spin(minimal_publisher)
    except (KeyboardInterrupt, ExternalShutdownException):
        pass


if __name__ == '__main__':
    main()
