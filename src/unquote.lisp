(in-package :definition)




(declaim (ftype (function (cons) (or cons symbol)))
	 (inline unquote))


(cl:defun unquote (any)
  (declare (type cons any))
  (cadr any))
