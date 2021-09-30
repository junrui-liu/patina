# Projects

## Set-up

You will need `opam` to run and compile OCaml code. Here is an [installation guide](https://github.com/fredfeng/CS162/blob/master/sections/section1/install_ocaml.md), written by Bryan Tan for a different course that also uses OCaml for the assignments.

Once you have `opam`, you can create a "switch" so that the OCaml version and other dependencies you installed for this course won't contaminate the global environment:

    opam switch create cs160 ocaml-base-compiler.4.13.0

This will create a new switch called `cs160`, and will compile an OCaml compiler inside that switch.