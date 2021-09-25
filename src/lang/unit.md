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
print_int(8);
print_int(9)
```
This should be read as a single expression `(.. ; ..)` that contains two sub-expressions, namely, `print_int(8)` and `print_int(9)`.

To evaluate a sequence expression `e1; e2; ...; en`, we evaluate each of `ei` sequentially, discarding the values of all expressions except for the last expression `en`.
The value of `en` will become the value of the overall sequence expression `e1; e2; ...; en`.
In the previous example, the value of the overall sequence expression is the value of `print_int(9)`, which is `()`, the unit value. The value of `print_int(8)`, however, is suppressed by the semicolon.[^1]

Using the semicolon, you can suppress not only the unit value, but also any type of value. As an example,
```rust,no_run,noplayground
(1; print_int(2); 3) + 4
```
evaluates to `7`, because the left operand of the addition evaluates to `3`. Although `1` evaluates to `1` and `print_int(2)` evaluates to `()`, those values are ignored. Still, the _effect_ of evaluating `print_int(2)` will be observable, as the character `2` will be printed to the standard output.

_Test your understanding_: Consider the sequence `1; print_int(2); 3`. What if you would also like to suppress the value of the last expression, i.e. `3`? Can you express it using the Patina features introduced so far?[^2]

### Variable Bindings

Printing something to the standard output isn't the only kind of side effect in Patina. Variable bindings are another kind of scenario. In Patina, variables are created using the _let expression_:
```rust,no_run,noplayground
let x: T = e
```
This expression will create a new variable `x` of type `T`, which is initialized with the value of expression `e`. Then, `x` becomes available ("in-scope") in subsequent expressions _within the same sequence_.

For example,
```rust,no_run,noplayground
let x: int = 5;
let y: int = x + 1;
print_int(x * y)
```
will print out `30`, but
```rust,no_run,noplayground
if true then {
  let x: int = 5;
  print_int(x)
} else {
  let y: int = 6;
  print_int(y)
};
print_int(x * y)
```
will result in a compile-time error due to the last line: variables `x` and `y` are only available inside their respective branches, and are not available outside the if-then-else expression.

Let-expressions themselves have type `unit`.


### Variable Assignments

In addition to reading the value of an variable, you might also want to mutate it. Patina has _assignment expressions_ for this purpose. For example,
```rust,no_run,noplayground
let x: int = -1;
x = x + 2;
print_int(x)
```
initializes a new integer variable `x` with value `-1`, increments the value of `x` by `2`, and prints `1` to the screen.


### While Expressions
Patina's _while expressions_ are very similar to the while loops in other imperative languages like C or Java. A while expression has a _condition_ and a _body_. To evaluate a while expression, we first evaluate the condition. If it is `true`, then we evaluate the body expression repeatedly until the condition becomes `false`. Otherwise, the body expression will not be evaluated. For example,
```rust,no_run,noplayground
let i: int = 0;
while i < 3 {
  i = i + 1
};
print_int(i)
```
will print `3` to the standard output.

The condition should have type `bool`, and the body have type `unit`. The overall while expression will have type `unit`.

To simplify its compiler, Patina has no `break` or `continue` constructs.


[^1]: For those of you familiar with Java or C, the semicolon has a different meaning here. In Java or C, a semicolon signals the end of a simple statement. In Patina, a semicolon is always sandwiched between two expressions, and it means that "we don't care the value of the first expression, but please evaluate it before you evaluate the expression after the semicolon."



[^2]: Yes, you can write `1; print_int(2); 3; ()`, which evaluates to the unit value `()`.