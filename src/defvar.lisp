(in-package :definition)




(cl:defmacro defvar (name type &key ((= value)) ((:documentation doc)))
  `(progn
	 (declaim (type ,(unquote type) ,name))
	 (cl:defvar ,name ,value ,doc))
