(in-package :definition)




(cl:defmacro defparameter (name type = value &key ((:documentation doc)))
  (if (not (eq = '=))
	  (error "The argument = must be a symbol =")

	  `(progn
		 (declaim (type ,(unquote type) ,name))
		 (cl:defparameter ,name ,value ,doc))))
