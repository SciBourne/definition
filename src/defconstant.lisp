(in-package :definition)



(cl:defmacro defconstant (name type = value &key (documentation nil))
  (if (not (eq = '=))
	  (error "The argument = must be a symbol =")

	  `(progn
		 (declaim (type ,(unquote type) ,name))
		 (cl:defconstant ,name ,value ,documentation))))
