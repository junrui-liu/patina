# Introduction

[Chapter 1](./overview/overview.md) introduces you to the Patina programming language, for which you will be writing your own compiler!

Patina is an imperative language whose syntax is very similar to the [Rust programming language](https://www.rust-lang.org/). We designed it so that it is big enough to let you write many interesting programs (e.g. your favorite sorting algorithm), but small enough that a compiler for Patina can be implemented in a quarter-long course.


[Chapter 2](./ref.md) describes the language more formally, specifying the syntax, dynamic semantics, and static semantics of each language construct.


[Chapter 3](./setup/setup.md) walks you through setting up OCaml on your computer, which you will need for the programming projects, described in [Chapter 4](./projects/projects.md). The projects build on each other, and in the end you will have a complete, optimizing compiler that can translate any valid Patina program down to x86 assembly, which your computer will be able to execute.