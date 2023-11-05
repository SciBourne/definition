(in-package :cl-user)




(defpackage :definition
  (:use        #:cl)
  (:nicknames  #:def)

  (:shadow     #:defun
               #:defmethod)

  (:export     #:defun))




(unlock-package :definition)
