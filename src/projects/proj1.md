## Project 1: OCaml

To be released on 10/4. In the meantime, make sure you have OCaml set up.
<!-- 
In this project, you will be building a sequence of interpreters of increasing capabilities, each supporting more features of Patina than the previous one. But first, let's get some warm-up with recursion.


### Part 1 \[★\]
> Goal of this exercise: Practice tuples, options, and recursion over lists.

An association list is a `('k * 'v) list` that can be used as a lookup table, mapping keys of type `'k` to values of type `'v`. To insert a key-value pair into an association list, we simply insert the pair to the beginning of the list:
```ocaml
let insert (k: 'k) (v: 'v) (al: ('k * 'v) list) : ('k * 'v) list =
  (k,v) :: al
```

The complementary `lookup_opt` function looks like
```ocaml
let rec lookup_opt (k: 'k) (al: ('k * 'v) list) : 'v option =
  (* your code here *)
```
To query the value associated with a key `k` in the list, we find the frontmost pair whose key matches `k`, and we return the associated value. However, `k` might not be in our list. That's why the return type is `'v option`, instead of `'v`.

For example,
```ocaml
let al = insert "x" 3 (insert "y" 2 (insert "x" 1 []))
(* al is now [("x", 3), ("y", 2), ("x", 1)] *)

let _ = assert (lookup_opt "y" al = Some 2)
let _ = assert (lookup_opt "x" al = Some 3)
let _ = assert (lookup_opt "z" al = None)
```

Provide a recursive implementation for `lookup_opt`.

---

### Part 2 \[★★\]

> Goal of this exercise: Practice pattern matching and functions as first-class objects.

Patina\\(^{arith}\\) is a subset of Patina that only contains integer constants and binary expressions. Expressions will be represented in OCaml as abstract syntax trees as follows:
```ocaml
type binop = Add | Sub | Mul | Div
type expr = Int of int
          | Binary of binop * expr * expr
```

Here are two Patina\\(^{arith}\\) expressions represented as `expr`:
```ocaml
(* e1 represents the concrete expression "1 + 2 * 3" *)
let e1 =
  Binary (
    Add,
    Int 1,
    Binary (Mul, Int 2, Int 3))

(* e2 represents the concrete expression "3 * 4 - 30 / 6" *)
let e2 =
  Binary (
    Sub, 
    Binary (Mul, Int 3, Int 4),
    Binary (Div, Int 30, Int 6))
```

Below is a partially written interpreter for Patina\\(^{arith}\\). The main interpreter function is `interpret`, which evaluates a Patina\\(^{arith}\\) expression to an OCaml integer.

```ocaml
let interpret_op (op: binop) : int -> int -> int =
  match op with
  (* your code here *)

let rec interpret (e: expr) : int =
  match e with
  | Int n -> n
  | Binary (op, e1, e2) -> 
    (interpret_op op) (interpret e1) (interpret e2)
```

`interpret` calls a helper function, `interpret_op`, which evaluates binary integer operators (`binop`) to their interpretations as OCaml functions (`int -> int -> int`).

Complete the definition for `interpret_op`.

_Hint_: use [anonymous functions](https://cs3110.github.io/textbook/chapters/basics/functions.html?highlight=anonymous#anonymous-functions).

---

### Part 3 \[★★★\]

> Goal of this exercise: Practice pattern matching and simulating "state changes" in a functional way.

Now let us extend Patina\\(^{arith}\\) into Patina\\(^{let}\\), which additionally supports variable bindings and sequences:
```ocaml
type binop = Add | Sub | Mul | Div
type expr = Int of int
          | Binary of binop * expr * expr
          | Id of string             (* new *)
          | Let of string * expr     (* new *)
          | Seq of expr list         (* new *)
```

A `Let` expression is a `string * expr` pair, where the value of the `expr` will be bound to the `string` name. The name will available in subsequent expressions in the parent `Seq` expression.

Extend your interpreter in Part 2 to support the new language constructs. Your `interpret` will have the following type:
```ocaml
let interpret (e: expr) : int = 
  (* your code here *)
```

The evaluation rules for the newly added constructs are as follows:
- A `Let` expression evaluates to `0`.
- A `Seq` expression evaluates to the value of the last expression in the sequence.
- An `Id` expression evaluates the value associated with the identifier string.

For example,
```ocaml
(* `e1` represents the concrete expression "let x: int = 2; x * 3" *)
let e1 = 
  Seq [
    Let ("x", Int 2);
    Binary (Mul, Id "x", Int 3)
  ]

(* `e2` represents the concrete expression
  let x : int = 1;
  { let x : int = 2; x };
  x *)
let e2 =
  Seq [
    Let ("x", Int (-1));
    Seq [
      Let ("x", Int 2);
      Id "x"
    ];
    Id "x"
  ]

let _ = assert (interpret e1 = 6)
let _ = assert (interpret e2 = (-1))
```

Provide an implementation for `interpret`.

`interpret` itself may or may not be recursive, as long as it has the right type. You may assume that the test cases won't contain semantic or runtime errors, such as reference to unbound variables, or empty sequences.

_Hints:_ 
1. You may want to use some kind of environment (e.g., what you did in Part 1) to keep track of the values of variables that are in scope:
    ```ocaml
    type environment = (string * int) list
    ```

2. `interpret` itself can be non-recursive, and can call another helper function that actually evaluates the expressions recursively. The helper function may look like:
    ```ocaml
    let rec interpret' (e: expr) (env: environment) : (environment, int) =
      match e with
      (* ... *)
    ```
    Compared to `interpret`, the function `interpret'` additionally takes in an `environment`, and additionally returns an `environment` augmented by `Let` expressions [^1].

3. Be very careful how `Seq` and your environment interact.
---

### _(Bonus)_ Part 4 \[★★★\]
Extend your interpreter to support Patina\\(^{ref}\\), which additionally contains assignments and while loops:
```ocaml
type binop = Add | Sub | Mul | Div
type loc = string
type expr = Int of int
          | Binary of binop * expr * expr
          | Id of string
          | Let of string * expr
          | Seq of expr list
          | Assign of loc * expr    (* new *)
          | While of expr * expr    (* new *)
```

Both `Assign` and `While` evaluate to `0`. A `While` expression is an `expr * expr` pair, where the first item of the pair is the condition, and the second item is the loop body.

_Hint_: You may want to use [`ref` cells](https://cs3110.github.io/textbook/chapters/mut/refs.html) for your environment:
  ```ocaml
  type environment = (string * int ref) list
  ```

---


You will gain some familiarity with the full Patina language by writing some short programs and playing with them using a prototype interpreter. 

[^1]: This helper function is an example of what's called a [state monad](http://learnyouahaskell.com/for-a-few-monads-more#state), which is a functional way of simulating "state changes" without using mutable variables. (The linked article is for people learning a different functional language called Haskell, but the syntax involved in that particular discussion is quite similar to OCaml's syntax.) 
-->