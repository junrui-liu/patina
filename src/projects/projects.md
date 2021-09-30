# Projects



## Set-up

You will need `opam` to run and compile OCaml code. Here is an [installation guide](https://github.com/fredfeng/CS162/blob/master/sections/section1/install_ocaml.md), written by Bryan Tan for a different course that also uses OCaml for the assignments.

Once you have `opam`, you can create a "switch" so that the OCaml version and other dependencies you installed for this course won't contaminate the global environment. Inside your terminal, run

    opam switch create cs160 ocaml-base-compiler.4.13.0
    eval $(opam env)

This will create a new switch called `cs160`, and will compile an OCaml compiler inside that switch.

Each project may have additional set-up.



## Running the Interpreter

Once it's done, you can fire up the `ocaml` interpreter in your terminal to play with the language (`ocaml` installed with the compiler). But we recommend using `utop` as an alternative. To install it, run
    
    opam install utop
    eval $(opam env)

`opam` will install additional dependencies required by `utop`. Once everything is done, simply run `utop` to open the interpreter, and type OCaml expressions or definitions to see what results they give.



## Running OCaml Programs
If you have a `.ml` file, say `hello.ml` that contains the following code:
```
let s = "hello" 
let _ = print_endline s
```

you can run `utop hello.ml` to let `utop` interpret your program from start to finish. You will see "hello" printed on your terminal.

Alternatively, you can run `utop` with no arguments, and load your program dynamically with

    #use "hello.ml";;

You will also see "hello" printed on your screen, but this time `utop` won't exit. So you can continue to use the interpreter, with everything defined in `hello.ml` now available for use. For instance, the variable `s` containing the string `"hello"` is still available, so you can continue to do

    print_endline s;;
inside `utop`.