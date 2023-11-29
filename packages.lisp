(in-package :cl-user)




(defpackage :definition
  (:use        #:cl)
  (:nicknames  #:def)

  (:shadow     #:defun
               #:defconstant)

  (:export     #:defun
			   #:defconstant))




(unlock-package :definition)
