## CS160 Assignment 5: Optimizations

**Assignment due: Friday, December 10th 11:59PM**

## Submission and Grading
TBF

## What you need to implement
In this assignment, you will implement the optimization phase for your compiler. Optimizations are commonly performed on [intermediate representations](https://en.wikipedia.org/wiki/Intermediate_representation). However, for simplicity you will directly optimize on the following subset of Patina AST, which excludes variable mutation, arrays, and while loops:
```ocaml
type expr =
  | Const of const
  | Id of string
  | Let of string * typ * expr
  | Unary of unop * expr
  | Binary of binop * expr * expr
  | Ite of expr * expr * expr
  | Seq of expr list
  | Call of string * expr list
```

On minimum, you should implement constant folding and propagation:
1. Constant folding partially evaluates an expression as much as it can. For example, the nested binary expression `100 * 100 * 100` will be replaced with a single constant, `1000000`.
2. Constant propagation replaces references to constant variables with their actual values. For instance, the sequence `{ let x: int = 1; print_int(x) }` will be transformed into `{ let x: int = 1; print_int(1) }`.

Fill in the body of function `fold_constant` in `optimize.ml`. As always, you will likely need some kind of environment (to do constant propagation). Think about what kind of environment might be good. Then, replace `bottom` with a type of your choice on the following line in `optimize.ml`:
```ocaml
type env = (string * bottom) list
```
and perform `fold_constant` using this environment.

We provided a driver that performs your optimizations on Patina source programs. You can invoke it with
```
dune exec ./patina.exe -- test.pt
```

It will print out the ASTs for the original program as well as the optimized program. It also makes sure that the optimized program is well-typed.