(* qcheck.sig -- main signatures for QCheck library
 * Copyright ©2004 Christopher League <league@contrapunctus.net>
 * 
 * This library is free software; you may redistribute and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; see the file COPYING. 
 *)

signature QCHECK = sig
(*<<*)
structure Gen : GENERATOR 
structure FileSys : FILESYS 
structure Settings : SETTINGS
(*@ The @code{Gen} structure contains random value generators for all
the basis types, including aggregates like vectors and lists.  It
also contains a rich library of combinators such as @code{zip},
@code{map}, and @code{filter}.  @xref{Generating test cases}.

@code{FileSys} is provided to make it easy to use lines in a file
or files in a directory as test cases.  @xref{Specifying test
cases}. @code{Settings} contains various user-customizable settings,
including user-definable output styles.  @xref{Settings}.
 *)
include PROPERTY
(*@ This signature contains functions for specifying
properties and observing the distribution of test cases.  In
preceding sections, we met two of its members: @code{pred}
converts a predicate (boolean function) on a given type to a
property, and @code{==>} creates a conditional property.  A
property over a given type @code{t} has type @code{t prop}.
@xref{Properties}.
 *)
(*@ Two types are useful for discussing the parameters of the various
@code{check} functions:
 *)
type ('a,'b) reader = 'b -> ('a * 'b) option  (*@tindex reader*)
type 'a rep = ('a -> string) option           (*@tindex rep*)
(*@ An @code{('a,'b) reader} pulls objects of type @code{'a} from a
stream of type @code{'b}.  In this case, the objects are test
cases of some type.  (This is defined the same way as
@code{StringCvt.reader}.) The type @code{'a rep} is an (optional)
method for rendering test cases as strings.  It is used in case
there are counter-examples to be printed.
 *)
(*@ Now, the most general function for invoking QCheck is called
@code{check}.  It takes 3 (curried) parameters:
 *)
val check : ('a,'b) reader * 'a rep ->   (*@findex check*)
            string * 'a prop -> 
            'b -> unit
(*@ @enumerate
@item
The first parameter is a reader and representation pair.  It contains
everything the checker needs to know about the type of the test cases,
and the same pair can be reused to check additional properties of the
same type.

@item
Next is the property name and specification.  This parameter will be
different for each property checked.  The name is just a string used
to distinguish the results of this test in the output.

@item
Finally, you provide a stream of test cases.  The source of the test
cases is arbitrary, as long as a matching reader is provided.  They
could be randomly generated, read from a data structure, extracted
from the file system, etc.  

@end enumerate 

We provide two specializations of @code{check} that are useful in
particular circumstances.  First, @code{checkGen} is for checking
randomly generated test cases.  The random number stream is implicit,
and the reader is always a generator from the @code{Gen} module.
*)
val checkGen : 'a Gen.gen * 'a rep ->     (*@findex checkGen*)
               string * 'a prop -> unit
(*@ Second, if we just want to check one particular test case, the
reader is trivial (and therefore omitted), and the `stream' is just the
test case itself: 
*)
val checkOne : 'a rep -> string * 'a prop -> 'a -> unit
(*@findex checkOne*)
(*@

Finally, the @code{Qcheck} structure includes a pair that can be
useful in determining the version of QCheck you are using.
*)
val version : int * int (*@findex version*)
(*>>*)
end
