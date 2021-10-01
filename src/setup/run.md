## Interacting with OCaml Code

### Interacting without Source Files

Simply run `utop` on your terminal. You can enter OCaml expressions and let bindings.

### Running an OCaml Program

Open your favorite code editor, and create a file called `hello.ml` that contains the following lines:
```ocaml
let s = "hello" 
let _ = print_endline s
```

Run `utop hello.ml` to let `utop` interpret your program from start to finish. You will see "hello" printed on your terminal.

Alternatively, you can run `utop` with no arguments, and load your program dynamically with
```
#use "hello.ml";;
```

You will also see "hello" printed on your screen, but this time `utop` won't exit. So you can continue to use the interpreter, with everything defined in `hello.ml` now available for use. For instance, the variable `s` containing the string `"hello"` is still available, so you can continue to do
```
print_endline s;;
```

### Building an OCaml Project with Multiple Files

You will need a build system, like [dune](https://github.com/ocaml/dune), to manage OCaml programs that spread over more than one file. But for the course projects we will set up everything for you. So no need to worry about this scenario!