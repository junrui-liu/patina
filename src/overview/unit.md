## Unit expressions

Patina expressions don't always need to evaluate to an `int` or `bool` value. For some expressions, their only purpose is to have some side effect upon the execution of the program. Printing something to standard output is among one of those scenarios. In Patina, evaluating the expression
```rust,no_run,noplayground
print_int(8)
```
has the effect of printing the integer `8` to the standard output, but the expression itself doesn't evaluate to any integer value (i.e., it is meaningless to write `print_int(8) + 2`).

In Patina, expressions like this have a special type called `unit`. An expression of `unit` type evaluates to a special value called the _unit value_, written as `()`.  Note that the unit value `()` is the only value that inhabits type `unit`. Compare it with type `int`, which harbors many values, such as `0`, `-3`, `42`, `1024`, ...


### Sequencing
It is often useful to string together multiple unit expressions with side effects, and evaluate them one by one. Say we would like to print two integers. In Patina, we can express this using a _sequence expression_:
```rust,no_run,noplayground
{
  print_int(8);
  print_int(9)
}
```
This should be understood as a single overall expression `e` written as `{ e1 ; e2 }`. The expression `e` contains two sub-expressions, namely, `print_int(8)` as `e1` and `print_int(9)` as `e2`.

To evaluate a sequence expression `{ e1; e2; ...; en }`, we evaluate each `ei` sequentially, discarding the values of all expressions except for the last expression `en`.
The value of `en` will become the value of the overall sequence expression.

So in the previous example, the value of the overall sequence expression is the value of `print_int(9)`, which is `()`, the unit value. The value of `print_int(8)` is suppressed.[^1]

A sequence has to have at least one expression, but it may very well have just a single expression, as you have encountered in a previous if-then-else expression:
```rust,no_run,noplayground
if 0 <= 1 then {
  2 + 3
} else {
  3 * 4
}
```
Here, the `then` branch contains the sequence `{ 2 + 3 }` consisting of a single expression `2 + 3` (and similarly with the `else` branch).

Sequences also appear as while expressions's body and functions' body, both of which we will introduce shortly.


### Variable Declaration

Sequence expressions not only are useful for specifying sequential computation with side effects, but they also delineate how long variables declared inside them should live. Let's first see how variables are declared in Patina.

Variable declaration is another kind of side effect in addition to printing to standard output. In Patina, variables are created using _let-expressions_:
```rust,no_run,noplayground
let x: T = e
```
This expression will create a new variable `x` of type `T`, which is initialized with the value of expression `e`. Then, `x` becomes available ("in-scope") in subsequent expressions _within the same sequence_.

For example,
```rust,no_run,noplayground
{
  let x: int = 5;
  let y: int = x + 1;
  print_int(x * y)
}
```
will print out `30`, but
```rust,no_run,noplayground
{
  {
    let x: int = 5;
    let y: int = x + 1
  };
  print_int(x * y)
}
```
will result in a compile-time error due to the last line: variables `x` and `y` are only available inside the inner sequence, and are not available in the outer sequence.

Let-expressions themselves have type `unit`.


### Variable Assignments

In addition to reading the value of an variable, you might also want to mutate it. Patina has _assignment expressions_ for this purpose. For example,
```rust,no_run,noplayground
{
  let x: int = -1;
  x = x + 2;
  print_int(x)
}
```
initializes a new integer variable `x` with value `-1`, increments the value of `x` by `2`, and prints `1` to the screen.


### While Expressions
Patina's _while expressions_ are very similar to the while loops in other imperative languages like C or Java. A while expression has a _condition_ and a _body sequence_:
```rust,no_run,noplayground
while cond {
  e1;
  e2;
  ..;
  en
}
```

To evaluate a while expression, we first evaluate its condition:
- If it is `true`, then we evaluate the body sequence repeatedly until the condition evaluates to `false`.
- Otherwise, the body sequence will not be evaluated.

For example,
```rust,no_run,noplayground
{
  let i: int = 0;
  while i < 3 {
    i = i + 1
  };
  print_int(i)
}
```
will print `3` to the standard output.

The condition should have type `bool`, and the body have type `unit`. The overall while expression will have type `unit`.

For simplicity, Patina has no `break` or `continue` constructs.


[^1]: For those of you familiar with Java or C, the semicolon has a different meaning here. In Java or C, a semicolon signals the end of a simple statement. In Patina, a semicolon is part of the syntax for sequence expressions, so they must appear together with a surrounding pair of curly braces. Moreover, a semicolon is always sandwiched between two expressions, and it means that "we don't care the value of the first expression, but please evaluate it before you evaluate the expression after the semicolon."