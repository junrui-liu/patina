## Installing OCaml

Once you have `opam`, you can create a "switch" so that anything you installed for this course won't contaminate the global environment.

Inside your terminal, run
```bash
opam switch create cs160 ocaml-base-compiler.4.13.0
eval $(opam env)
```

This will create a new switch called `cs160`. It will also compile the tools necessary to run OCaml programs, including a compiler (`ocamlc`) and an interpreter (`ocaml`).

Once the switch is created, you can play with the interpreter by running `ocaml` in your terminal.

But we recommend using `utop` as an alternative. To install it, run
```bash
opam install utop
```

`opam` will install any additional dependencies required by `utop`.

