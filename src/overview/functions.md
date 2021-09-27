## Functions

In Patina, functions are the only creatures that are _not_ expressions. They are declared at the top level, along with the mandatory `main` function.

By convention, `main` doesn't take in any argument, and always has return type `unit`:
```rust,no_run,noplayground
fn main() -> unit
```

Other functions can have any return type (`unit`, `bool`, `int`, or `[int]`), and their arguments also need to be annotated with types. The body of each function is a _sequence expression_ whose type must match the declared return type.


### Recursion

Functions can be recursive. This program will print out `55`, the tenth fibonacci number (indexing from zero).
```rust,no_run,noplayground
fn fibonacci(x: int) -> int {
  if x == 0 || x == 1 then {
    x
  } else {
    fibonacci(x-1) + fibonacci(x-2)
  }
}

fn main() -> unit {
  print_int(fibonacci(10))
}
```

You can also define mutually recursive functions:
```rust,no_run,noplayground
fn even(x: int) -> bool {
  x == 0 || odd(x - 1)
}

fn odd(x: int) -> bool {
  x == 1 || even(x - 1)
}

fn main() -> unit {
  print_bool(odd(3))
}
```
This program will print out `true`.



### Built-in Functions

Patina also provides the following built-in functions, which can be called freely in Patina programs:
```rust,no_run,noplayground
// print a boolean to stdout
fn print_bool(x: bool) -> unit

// print an integer to stdout
fn print_int(x: int) -> unit

// print an array of integers to stdout
fn print_arr(xs: [int], length: int) -> unit
 
// print the newline character '\n' to stdout
fn print_ln() -> unit

// allocate a new, zero-initialized array of specified length
fn alloc(length: int) -> [int] 
```

For example, the following program
```rust,no_run,noplayground
fn main() -> unit {
  print_bool(!true);
  print_ln();

  print_int(0);
  print_int(1);
  print_ln();
  
  let xs: [int] = alloc(3);
  xs[0] = 3;
  xs[1] = 2;
  xs[2] = 1;
  print_arr(xs, 3);
  print_ln()
}
```
will print out
```rust,no_run,noplayground
false
01
3 2 1
```