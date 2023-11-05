(in-package :definition)




(declaim (inline symbol-to-keyword))

(cl:defun symbol-to-keyword (symbol)
  (read-from-string
   (format nil ":~a" symbol)))
