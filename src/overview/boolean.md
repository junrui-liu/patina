## Boolean Expressions

The most basic boolean expressions are boolean constants `true` and `false`. More complex boolean expressions can be constructed in two ways:
1. by comparing two integer expressions using the _comparison operators_: `==` (equal), `!=` (not equal), `<` (less than), `>` (greater than), `<=` (less than or equal to) and `>=` (greater than or equal to),
2. by composing smaller boolean expressions using the _boolean operators_: `!` (not), `&&` (and), `||` (or).

For instance, the following expression evaluates to `true`:
```rust,no_run,noplayground
(3 > 4 && (1 == 1)) || !false
```

Boolean expressions have type `bool`.



### Branching

Patina supports _if-then-else expressions_, which evaluates to the then-expression when the condition expression evaluates to `true` or the else-expression otherwise. For example, the expression
```rust,no_run,noplayground
if 0 <= 1 then {
  2 + 3
} else {
  3 * 4
}
```
evaluates to `5`.[^1]

Note that it is possible to simulate "else if" clauses by nesting multiple if-then-else. For example,
```rust,no_run,noplayground
if 0 == 1 then {
  3
} else {
  if 0 == 2 then {
    5
  } else {
    7
  }
}
```
evaluates to `7`.

[^1]: For those of you familiar with C++ (or Java), Patina's if-then-else expressions correspond to C++'s conditional expressions. For example, the if-then-else expression here would translate to `0<=1 ? (2+3) : (3*4)` in C++. Importantly, Patina's if-then-else expressions are different from C++'s if-_statements_. Statements don't produce values, but expressions do.