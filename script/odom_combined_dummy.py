#!/usr/bin/env python
import rospy
from nav_msgs.msg import Odometry 

rospy.init_node("dummy_odom_combined")
pub = rospy.Publisher("odom_combined", Odometry, queue_size = 10)
sub = rospy.Subscriber("odom", Odometry, lambda odom_msg: pub.publish(odom_msg))
rospy.spin()




