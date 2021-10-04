# CS160 Assignment 1: OCaml

**Assignment due: Monday, October 18 11:59PM**

## Introduction

In this assignment, you will get some practice with recursion and pattern matching by building a sequence of interpreters for increasingly large subsets of the Patina programming language.

There are 3 main parts to the assignment (Problems 1-3), as well as a bonus problem (Problem 4). For each problem, we'll provide a file containing some starter code. They can be found in the [CS160 GitHub repo](https://github.com/fredfeng/CS160/tree/main/assignments/as1):
- `assoc.ml` (Problem 1)
- `patina_arith.ml` (Problem 2)
- `patina_let.ml` (Problem 3)
- `patina_ref.ml` (Problem 4)

You will fill in the missing parts of the code that are marked with `(* your code here *)`.

If you're stuck for more than 15 minutes on a problem, try to ask a general question on slack, or if you can't, direct message a TA.

Respect academic integrity; no sharing solutions, code or otherwise. You may use the internet, but not for finding solutions to these particular problems.


## Submission and Grading
We are working on setting up the autograder. This section will be updated once the submission system is ready.


## Problem 1 \[★\]
> Goal of this exercise: Practice tuples, options, and recursion over lists.

In this problem, you will implement the [association list](https://en.wikipedia.org/wiki/Association_list) data structure, which you may need for a later problem.

Association lists are the simplest kind of lookup tables. In OCaml, they are `('k * 'v) list` that map keys of type `'k` to values of type `'v`. To insert a key-value pair into an association list, we simply insert the key-value pair to the beginning of the list:
```ocaml
let insert (k: 'k) (v: 'v) (al: ('k * 'v) list) : ('k * 'v) list =
  (k,v) :: al
```
That is, `insert` takes a key and a value, as well as a list of keys and values, and inserts the key-value pair to the beginning of the list.

Note that the key's and value's types are not concrete, because the `insert` function is designed to work over any two key value types (an example of _polymorphism_). However, the list that the key-value pair is being inserted into must be a list of the correct type.

You will implement the complementary `lookup_opt` function. It looks like
```ocaml
let rec lookup_opt (k: 'k) (al: ('k * 'v) list) : 'v option =
  match al with
  | _ -> failwith "Not yet implemented" (* your code here *) 
```
To query the value associated with a key `k` in the list, we find the frontmost pair whose key matches `k`, and we return the associated value. 
However, our query `k` might not be in our list. That's why the return type is `'v option`, instead of `'v`.

In the example below, we insert
- `("x", 1)`,
- `("y", 2)`,
- `("x", 3)`

to the list `al` sequentially. Because `("x", 3)` is more recent than `("x", 1)`, the lookup `lookup_opt "x" al` returns the `Some 3`, instead of `Some 1`.
```ocaml
let al = insert "x" 3 (insert "y" 2 (insert "x" 1 []))
(* al is now [("x", 3), ("y", 2), ("x", 1)] *)

let _ = assert (lookup_opt "z" al = None)
let _ = assert (lookup_opt "y" al = Some 2)
let _ = assert (lookup_opt "x" al = Some 3)
```

Provide a recursive implementation for `lookup_opt`. Your code may not call any OCaml library functions.

> _Hints:_
> 1. **On `option` types.** A value of an `'a option` type can either be `None`, or `Some` of some value of type `'a`. Here is an example demonstrating the `option` type. If we want to divide integers without risking an exception, one solution is to use option types.
>     ```ocaml
>     let safe_divide (x: int) (y: int) : int option = 
>       if y = 0 then None else Some (x / y)
>     ```
> 2. **On recursion.** Recursion is simpler to use than loops in OCaml, and often better. You need to use `let rec` rather than `let` to declare a recursive function. Other than that, a function can call itself just as any other function. Here is a recursive function that computes the Hailstone sequence:
>     ```ocaml
>     let rec hailstone n = 
>       if n = 1 then
>         print_string "1 reached"
>       else if n mod 2 = 1 then
>         hailstone (3*n+1)
>       else
>         hailstone (n / 2)
>      ```
> 3. **On pattern-matching.** As seen in the course slides, the primary way that you interact with values is by case analysis.
>   The syntax for case analysis is via `match .. with ..` which maps each possible case to the desired expression.
>   All values that are part of the case need to be assigned to variables if you want to use them in the expression. For instance, the following function uses pattern matching to sum the first two elements of a list:
>     ```ocaml
>     let sum_of_first_2_elements (l: int list) : int =
>       match l with
>       | []          -> 0
>       | x :: []     -> x
>       | x :: y :: _ -> x + y
---

## Problem 2 \[★★\]

> Goal of this exercise: Practice pattern matching and functions as first-class objects.

Patina\\(^{arith}\\) is a subset of Patina that only contains integer constants and binary expressions. Expressions will be represented in OCaml as abstract syntax trees as follows:
```ocaml
type binop = Add | Sub | Mul | Div
type expr = Const of int
          | Binary of binop * expr * expr
```

Below are two Patina\\(^{arith}\\) expressions represented as `expr`: `e1` represents the concrete expression "1 + 2 * 3", while `e2` represents the concrete expression "3 * 4 - 30 / 6":
```ocaml
let e1 =
  Binary (
    Add,
    Const 0,
    Binary (Mul, Const 2, Const 3))

let e2 =
  Binary (
    Sub, 
    Binary (Mul, Const 3, Const 4),
    Binary (Div, Const 30, Const 6))
```

We provide you with a partially complete interpreter for Patina\\(^{arith}\\). The main interpreter function is `interpret`, which evaluates a Patina\\(^{arith}\\) expression to an OCaml integer.

```ocaml
let rec interpret (e: expr) : int =
  match e with
  | Const n -> n
  | Binary (op, e1, e2) -> 
    (interpret_op op) (interpret e1) (interpret e2)

and interpret_op (op: binop) : int -> int -> int =
  match op with
  | _ -> failwith "Not yet implemented" (* your code here *)
```

Here, `interpret` calls a helper function, `interpret_op`, which evaluates binary integer operators (`binop`) to their interpretations as OCaml functions (`int -> int -> int`). The binary operators have the usual interpretations. For instance, `interpret e1` should return `6`, and `interpret e2` should return `7`.

Complete the definition for `interpret_op`.

> _Hint:_ You are likely to find [anonymous functions](https://cs3110.github.io/textbook/chapters/basics/functions.html?highlight=anonymous#anonymous-functions) helpful here.
> 
> As an example, the following variable `three_anonymous` is a tuple of 3 anonymous functions so you can see how they're created:
> ```ocaml
> let three_anonymous =
>   ( (fun x -if x then 3 else 6),
>     (fun x -fun y -x ^ y),
>     (fun (a,b,c) -if a b then a-b else c) )
> ```
> The first takes a `bool` to an `int`, the second concatenates two `string`s, and the third compares integers. You will notice that the second is an anonymous function returning an anonymous function, whereas the third takes all its arguments as a triple. The former format is called "curried" and the latter "uncurried". Be careful to use the right one.



---

## Problem 3 \[★★★★\]

> Goal of this exercise: Practice pattern matching and simulating "state changes" in a functional way.

Now let us extend Patina\\(^{arith}\\) into Patina\\(^{let}\\), which additionally supports variable bindings and sequences:
```ocaml
type binop = Add | Sub | Mul | Div
type expr = Const of int
          | Binary of binop * expr * expr
          | Id of string             (* new *)
          | Let of string * expr     (* new *)
          | Seq of expr list         (* new *)
```

A `Let` expression is a `string * expr` pair, where the value of the `expr` will be bound to the `string` name. The name will available in subsequent expressions in the parent `Seq` expression.

The evaluation rules for the newly added constructs are as follows:
- A `Let` expression evaluates to `0`.
- A `Seq` expression evaluates to the value of the last expression in the sequence.
- An `Id` expression evaluates the value associated with the identifier string.

In the example below,
- `e1` represents the concrete Patina expression `{ let x: int = 2; x * 3 }`,
- `e2` represents the concrete Patina expression 
` { let x: int = -1; { let x: int = 2; x }; x }`
```ocaml
let e1 = 
  Seq [
    Let ("x", Const 2);
    Binary (Mul, Id "x", Const 3)
  ]

let e2 =
  Seq [
    Let ("x", Const (-1));
    Seq [ Let ("x", Const 2); Id "x" ];
    Id "x"
  ]

let _ = assert (interpret e1 = 6)
let _ = assert (interpret e2 = (-1))
```

`e1` evaluates to `6`, because the let-expression binds `"x"` to `Const 2`, and the binary expression `Binary (Mul, Id "x", Const 3)` evaluates to `6` when `Id "x"` is replaced with `Const 2`.

`e2` evaluates to `-1`, because the last `"x"` refers to the variable bound in the outer sequence.


Extend your interpreter in Problem 2 to support the new language constructs. Your `interpret` will have the following type:
```ocaml
let rec interpret (e: expr) : int = 
  failwith "Not yet implemented" (* your code here *)
```

You may assume that the test cases won't contain semantic or runtime errors, such as reference to unbound variables, or empty sequences.

> _Hints:_ 
> 1. You may want to use some kind of environment (recall what you did in Problem 1) to keep track of the values of variables that are in scope:
>    ```ocaml
>    type environment = (string * int) list
>    ```
> 
> 1. `interpret` itself can be non-recursive, and can call another helper function that actually evaluates the expressions recursively. The helper function may look like:
>    ```ocaml
>    let rec interpret' (e: expr) (env: environment) : (environment * int) =
>       match e with
>       ...
>    ```
>    Compared to `interpret`, the function `interpret'` additionally takes in an `environment`, and additionally > returns an `environment` augmented by `Let` expressions [^1].
> 
> 1. Be very careful how `Seq` and your environment interact. If you are unsure, the [Variable Declaration](../overview/unit.html#variable-declaration) section in the Patina language overview contains more examples and explanations.



---

## _(Bonus)_ Problem 4 \[★★★\]
Extend your interpreter to support Patina\\(^{ref}\\), which further supports assignments and while loops:
```ocaml
type binop = Add | Sub | Mul | Div
type expr = Const of int
          | Binary of binop * expr * expr
          | Id of string
          | Let of string * expr
          | Seq of expr list
          | Assign of string * expr    (* new *)
          | While of expr * expr       (* new *)
```

Both `Assign` and `While` evaluate to `0`. A `While` expression is an `expr * expr` pair, where the first item of the pair is the condition, and the second item is the loop body.

For more information about the semantics of assignment and while expressions, refer to the relevant parts in the section on [Unit Expressions](../overview/unit.html) in the Patina language overview.

> _Hint:_ You may want to use [`ref` cells](https://cs3110.github.io/textbook/chapters/mut/refs.html) for your environment:
>   ```ocaml
>   type environment = (string * int ref) list
>   ```

---


[^1]: This helper function is an example of what's called a [state monad](http://learnyouahaskell.com/for-a-few-monads-more#state), which is a functional way of simulating "state changes" without using mutable variables. (The linked article is for people learning a different functional language called Haskell, but the syntax involved in that particular discussion is quite similar to OCaml's syntax.) 
