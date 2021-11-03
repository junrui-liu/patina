# CS160 Assignment 3: Type Checking

**Assignment due: TBD**

In this assignment, you will implement a type checker for you Patina compiler.

## Instructions
1. Download the starter code [here](https://github.com/fredfeng/CS160/blob/main/assignments/as3/).
2. Make sure you have installed `dune` and `ppx_deriving` via `opam`, as required in AS2. You don't need to install anything new for this assignment. 
3. Replace `scanner.mll` and `parser.mly` with your own implementation from AS2.
4. Complete the type checker in `typecheck.ml` (described in greater details later).
5. As in the previous assignment, we provide you with a driver program (`patina.ml`) that takes in Patina source files and invokes your parser and type checker on them. Run the driver program with
    ```
    dune exec ./patina.exe -- <patina-source-file> 
    ```

## Submission and Grading
We will update this section once the autograder is ready.

## What You Need to Implement
> If you are feeling adventurous, you can start with an empty `typecheck.ml` file and build your type checker from scratch. The only requirement is that the file should export a function called `check_prog` with the following signature:
> ```ocaml
> val check_prog : Ast.prog -> unit
> ```
> This function takes in an `Ast.prog`. It returns unit if there's no type error, and raises `Error.TypeError` otherwise.

You will implement the typing rules described in the [reference manual](https://junrui-liu.github.io/patina/ref.html#typing-rules), as well as a few more semantic checks.

The `typecheck.ml` file contains a skeleton of the type checking algorithm. On a high level, it is quite similar to the `interpret'` function you wrote in AS1:
- The main type checking function, `check`, takes in an expression and some environment, and outputs a pair consisting of a new environment and some `result`.
- Previously, the `result` type was `int`, because your interpreter was evaluating the input expression to an integer. Now the `result` type is `Ast.typ` (which can be either `TUnit`, `TBool`, `TInt`, or `TArr`), because the type checker computes the type of the input expression (if the expression is well-typed).
- Previously, the `environment` type was `(string * int) list`, which maps identifiers to their integer values[^1]. Now the environment is called `tenv`, which stands for **t**yping **env**ironment. This is the \\(\Gamma\\) you have encountered in the typing rules, which maps identifiers to their declared types. The `check` function also takes in a **f**unction **env**ironment, which is the \\(\Delta\\) in the typing rules.

The structure of `check` is also quite similar to `interpret'`. It traverses the AST in a post-order/bottom-up manner, by pattern-matching on the input expression, recursively type-checking the sub-expressions (if any), and aggregates the types of the sub-expressions. You can see a concrete example in the partially written cases we've provided. For example, in the case of unary `Not` expressions,
```ocaml
| Unary (Not, e) ->
    let te = type_of e in
    expect e TBool te;
    return TBool
```
we first recursively type check the sub-expressions `e`. Then we assert that `e` have type `TBool`. Finally, we return the type of the overall unary expression, which is also `TBool`.

However, it is not always the case that an expression is well-typed. What should `check` return in those cases? Clearly, we can't return a type as we normally would, because that would mean that the ill-typed expression *has* a valid type. Instead, the way we handle ill-typed expressions in this assignment is through exceptions. You have probably encountered exceptions in other languages. In OCaml, to raise an exception `exn`, we simply say `raise exn`. To handle exception `exn` that might arise during the evaluation of an expression `e`, we write
```ocaml
try
  e
with
| exn -> (* exception handling code *)
```
If your type checker encounters a type error, it should raise a `TypeError`, which is defined in `error.ml`. **However, you don't need to raise exceptions explicitly using `raise` (and we recommend against doing that).** Instead, use the helper functions `error.ml`, who will raise the appropriate exceptions on your behalf.

Fill in the missing parts that are marked with `hole ()` in `typecheck.ml`.

In addition to the typing rules described in the reference manual, your type checker should also perform a few other semantic checks. For example, a program should only have one `main` function, which takes no argument and returns a unit. You can get some hints as to what kinds of semantic checks need to be performed, by looking at the helper functions in `error.ml`.

[^1]: You can think of the environment in AS1 as a lazy substitution table.