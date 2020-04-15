(load "package://fetcheus/fetch-interface.l")
(require "models/arrow-object.l")

(fetch-init)

(fetch)
(defun transmit ()
  (send *ri* :angle-vector-raw (send *fetch* :angle-vector) 1000)
  (send *ri* :wait-interpolation))

(send *fetch* :reset-pose)
(send *fetch* :torso_lift_joint :joint-angle 200)
(send *ri* :stop-grasp)
(transmit)

(defun show-whole (&optional (object-list nil))
  (let (co-gripper)
    (setq co-gripper (arrow))
    (send co-gripper :newcoords
          (send (send *fetch* :rarm :end-coords) :copy-worldcoords))
    (objects 
      (append (list *fetch* co-gripper) 
              object-list))
    ))

(setq *co-object* (arrow))
(send *co-object* :newcoords (make-coords :pos #f(950 0 1100) :rpy #f(0.0 0.3 1.54)))

(send *fetch* :rarm :inverse-kinematics
        (send *co-object* :copy-worldcoords)
        :rotation-axis t :check-collision t :use-torso nil)
(show-whole (list *co-object*))
(transmit)

(dotimes (i 5)
  (send *ri* :send-cmd-vel-raw 1 0)
  (unix:usleep 400000))
(send *ri* :wait-interpolation)
(unix:sleep 1)

(send *ri* :start-grasp :effort 0)
(send *fetch* :rarm :move-end-pos #f(0 0 100) :world)
(transmit)

(dotimes (i 5)
  (send *ri* :send-cmd-vel-raw -1 0)
  (unix:usleep 400000))





;(transmit)
#|
(dotimes (i 10)
  (send *ri* :send-cmd-vel-raw 10 0)
  (unix:usleep 0.5))
|#



