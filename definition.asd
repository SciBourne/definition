(in-package :asdf)



(defsystem :definition
  :author "Alexander Marchenko (SciBourne) <bourne-sci-hack@yandex.ru>"
  :description "Common Lisp eDSL for type declaration"

  :version "0.0.1"
  :license "MIT"

  :serial t
  :components ((:file "packages")
			   (:module "src"
				:components ((:file "unquote")
							 (:file "symbols")
							 (:file "defconstant")
							 (:file "defun")))))
