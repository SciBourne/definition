(in-package :definition)




(defparameter *compiler-option-keys*
  '(:optimize
    :inline
    :notinline
    :ignore
    :special
    :dynamic-extent))


(defparameter *lambda-list-keys*
  '(&optional
    &key
    &rest
    &body
    &aux
    &whole
    &environment
    &allow-other-keys))




;;
;; TODO: Remove default behavior
;;

(defmacro defun (name lambda-list &body body)
  (if (or (null lambda-list)
		  (and (car lambda-list)
			   (symbolp (car lambda-list))))

      `(cl:defun ,name ,lambda-list
		 ,@body)

      (multiple-value-bind (proclamation restored-lambda-list declarations)
		  (parse-lambda-list name lambda-list)

		(if declarations
			`(progn ,proclamation
					(cl:defun ,name ,restored-lambda-list
					  ,declarations
					  ,@body))

			`(progn ,proclamation
					(cl:defun ,name ,restored-lambda-list
					  ,@body))))))




(declaim (inline arg-parse))

(cl:defun parse-lambda-list (func-name typed-lambda-list)
  (let ((head  (car typed-lambda-list))
		(tail  (cdr typed-lambda-list)))

    (multiple-value-bind (arg-symbols
						  arg-types
						  supplied-symbols

						  lambda-list
						  spec-lambda-list)

		(arg-parse head)

      (let* ((arg-declarations  (make-arg-declaraions    arg-symbols
														 arg-types
														 supplied-symbols))

			 (return-type       (parse-return-type       tail))
			 (compiler-options  (parse-compiler-options  tail))

			 (proclamation      (make-proclamation       func-name
														 spec-lambda-list
														 return-type))

			 (declarations      (make-full-declarations  arg-declarations
														 compiler-options)))

		(values proclamation
				lambda-list
				declarations)))))




(declaim (inline make-proclamation))

(cl:defun make-proclamation (func-name spec-lambda-list return-type)
  `(declaim (ftype (function ,spec-lambda-list ,return-type)
				   ,func-name)))




(declaim (inline make-declarations))

(cl:defun make-full-declarations (arg-declarations compiler-options)
  (when (or arg-declarations compiler-options)
    `(declare ,@arg-declarations ,@compiler-options)))




(declaim (inline parse-compiler-options))

(cl:defun parse-compiler-options (tail-typed-lambda-list)
  (loop for key in *compiler-option-keys*
		for identifier = (intern (symbol-name key))
		for value = (getf tail-typed-lambda-list key)

		when (and value
				  (eq key :optimize)
				  (consp value)
				  (symbolp (car value)))

		  collect `(,identifier ,value)
			into compiler-options

		else
		  when (and value (symbolp value))
			collect `(,identifier ,value)
			  into compiler-options

		else
		  when (and value (consp value))
			collect `(,identifier ,@value)
			  into compiler-options

		finally (return compiler-options)))




(declaim (inline parse-return-type))

(cl:defun parse-return-type (tail-typed-lambda-list)
  (let ((type (getf tail-typed-lambda-list (intern "->"))))
    (cond ((symbolp type)
		   (if type '* '(values &optional)))

		  ((and (consp (unquote type))
				(eq 'values (car (unquote type))))

		   (unquote type))

		  (t `(values ,(unquote type) &optional)))))




(declaim (inline make-arg-declaraions))

(cl:defun make-arg-declaraions (arg-symbols arg-types supplied-symbols)
  (nconc (mapcar (lambda (sym type) `(type ,type ,sym))
				 arg-symbols
				 arg-types)

		 (mapcar (lambda (sym) `(type boolean ,sym))
				 supplied-symbols)))




(declaim (inline arg-parse))

(cl:defun arg-parse (head-lambda-list)
  (let ((lambda-list       nil)
		(spec-lambda-list  nil)

		(arg-symbols       nil)
		(arg-types         nil)

		(supplied-symbols  nil))

    (loop for sym in head-lambda-list
		  for is-key = (member sym *lambda-list-keys*)

		  with key-space = nil
		  with position = :parameter

		  when is-key
			do (progn (setf position :parameter
							key-space sym)

					  (push sym lambda-list)

					  (unless (eq '&aux sym)
						(push sym spec-lambda-list)))

		  else
			when (and (null key-space) (eq position :parameter))
			  do (progn (setf position :typespec)
						(push sym lambda-list)
						(push sym arg-symbols))

		  else
			when (and (null key-space) (eq position :typespec))
			  do (setf position :parameter)
			  and do (cond ((symbolp sym)
							(push sym spec-lambda-list)
							(push sym arg-types))

						   ((consp sym)
							(push (unquote sym) spec-lambda-list)
							(push (unquote sym) arg-types)))

		  else
			when (eq '&rest key-space)
			  do (progn (push sym lambda-list)
						(push T spec-lambda-list))

		  else
			when (and key-space (eq position :parameter))
			  do (setf position :typespec)
			  and do (cond ((symbolp sym)
							(push sym lambda-list)
							(push sym arg-symbols))

						   ((consp sym)
							(cond ((symbolp (car sym))
								   (push sym lambda-list)
								   (push (car sym) arg-symbols))

								  ((consp (car sym))
								   (push sym lambda-list)
								   (push (cadar sym) arg-symbols)))

							(when (caddr sym)
							  (push (caddr sym) supplied-symbols))))


		  else
			when (and key-space (eq position :typespec) (eq '&key key-space))
			  do (setf position :parameter)
			  and do (progn (push (list (symbol-to-keyword (car arg-symbols))
										(cond ((symbolp sym) sym)
											  ((consp sym) (unquote sym))))

								  spec-lambda-list)

							(push (cond ((symbolp sym) sym)
										((consp sym) (unquote sym)))

								  arg-types))

		  else
			when (and key-space (eq position :typespec))
			  do (setf position :parameter)
			  and do (cond ((symbolp sym)
							(push sym arg-types)

							(unless (eq '&aux key-space)
							  (push sym spec-lambda-list)))

						   ((consp sym)
							(push (unquote sym) arg-types)

							(unless (eq '&aux key-space)
							  (push (unquote sym) spec-lambda-list)))))


    (values (reverse arg-symbols)
			(reverse arg-types)
			(reverse supplied-symbols)

			(reverse lambda-list)
			(reverse spec-lambda-list))))
