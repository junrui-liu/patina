# Overview

> This chapter gives an informal overview of the Patina language. More precise specifications can be found in the next chapter.

A Patina program consists of a list of function definitions, one of is a function called `main` that acts as the entry point of the program:
```rust,no_run,noplayground
fn my_function(<arg_name>: <arg_type>) -> <return_type> {
  ... // body of my_function
}

... // more function definitions

fn main() -> unit {
  ... // body of main
}
```

Patina is an expression-oriented language. This means that
1. Statements (like those in Java or C) don't have a distinguished status in Patina. Instead, everything is an expression; statements are just expressions that don't produce values, and they can be used anywhere an expression can be used.
2. The body of each function is simply an expression (i.e. there are no explicit `return` statements like in Java or C). Executing a function simply means evaluating the expression that is the body of the function.

Let's see what kinds of expressions we can write in Patina.