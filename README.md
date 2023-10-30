# Definition
Common lisp syntactic sugar for type declarations of function, macros and variables

<br>
<br>

## Table of contents

* [Examples](#examples)
  * [Dynamic binding](#dynamic-binding)
    * [Defconstant](#defconstant)
    * [Defparameter](#defparameter)
    * [Defvar](#defvar)
  * [Function and macros](#function-and-macros)
    * [Defun](#defun)
    * [Defmethod](#defmethod)
    * [Defmacro](#defmacro)
  * [Anonymous function](#anonymous-function)
    * [Lambda](#lambda)
  * [Lexical binding](#lexical-binding)
    * [Let](#let)
    * [Prog](#prog)
    * [Flet](#flet)
    * [Labels](#labels)
    * [Macrolet](#macrolet)
* [API Reference](#api-reference)

<br>
<br>

## Examples

<br>

### Dynamic binding

#### Defconstant

#### Defparameter

#### Defvar

<br>
<br>

### Function and macros

#### Defun

```common-lisp
(defun my-function ((x 'fixnum y 'fixnum) -> 'fixnum)
  (+ x y))
```

```common-lisp
(defun my-function ((x 'fixnum
                     y 'fixnum
                     z 'fixnum)

                    :optimize ((suffety 3)
                               (debug 3))
                    :ignore z

                    -> nil)
  (pprint (+ x y)))
```

<br>

#### Defmethod

#### Defmacro

<br>
<br>

### Anonymous function

#### Lambda

<br>
<br>

### Lexical binding

#### Let

#### Prog

#### Flet

#### Labels

#### Macrolet

<br>
<br>
<br>

## API Reference
















