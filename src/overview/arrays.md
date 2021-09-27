## Arrays


Patina supports dynamically allocated, zero-indexed arrays of integers.



### Array Allocation

We can create an array by calling the built-in function `alloc(..)` with a desired length. All elements will be initialized to `0`. For example,
```rust,no_run,noplayground
{
  let len: int = 3;
  let xs: [int] = alloc(len)
}
```
creates an array of length `3` and binds it to variable `xs`.



### Reading from an Array

Array elements can be accessed using _array-access expressions_, written as
```rust,no_run,noplayground
xs[i]
```
where `xs` is an array, and `i` is an integer expression.



### Writing to an Array Element

When an array access appears on the left-hand side of an assignment, the selected array element can be mutated, just like how the value of a variable is mutated. For example,
```rust,no_run,noplayground
{
  let singleton: [int] = alloc(1);
  singleton[0] = 100
}
```
changes the 0-th element of `singleton` from the default value of `0` to `100`.



### Aliasing

Aliasing is permitted in Patina. Two array variables can simultaneously refer to the same array object:
```rust,no_run,noplayground
{
  let xs: [int] = alloc(1);
  let ys: [int] = xs; // ys refers to the same array as xs
  ...
}
```

Arrays are passed by reference. So `[int]` is like a pointer to integer (`int *`) in C++. In the following example, both `reverse_1` and `reverse_2` reverses the input array. However, `reverse_1` modifies the input array _in place_, while `reverse_2` returns a _new_ array that's the reverse of the input array.
```rust,no_run,noplayground
fn reverse_1(xs: [int], len: int) -> unit {
  let mid: int = len / 2;
  let i: int = 0;
  while i < mid {
    xs[i] = xs[len - i - 1];
    i = i + 1
  }
}

fn reverse_2(xs: [int], len: int) -> [int] {
  let ys: [int] = alloc(len);
  let i: int = 0;
  while i < len {
    ys[i] = xs[len - i - 1];
    i = i + 1
  };
  ys
}
```



### Extent

Because you're not required to implement a garbage collector for your compiler, arrays will have infinite extent. In other words, an array cannot be destroyed once it has been allocated.

In the following example, even after the function `f` has returned, the array referred to by `xs` inside the body of `f` continues to exist in heap memory. But we can't access the array again, because its only name `xs` is no longer available outside the function body:
```rust,no_run,noplayground
fn f() -> unit {
  let xs: [int] = alloc(1); // xs refers to an array in heap memory
  ()
}

fn main() -> unit {
  f();
  ... // can't refer to that array anymore, since xs is out-of-scope
}
```
Once we've created an array, unless we always remember its name (or one of its names), the array would become an unnameable identity forever lost in heap memory. This is what's called a [memory leak](https://en.wikipedia.org/wiki/Memory_leak), which plagues programs written in unmanaged languages like C and C++. You will learn about solutions to this problem in the second half of the course, although you won't be required to implement them [^1].

[^1]: Also, learn how Rust prevents resource leaks using a [completely different approach](https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html). It's super cool!