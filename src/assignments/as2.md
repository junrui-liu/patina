# CS160 Assignment 2: Lexing and Parsing

**Assignment due: Friday, October 29 11:59PM**

## Changelog
1. The regular expression for `ID` should match underscores.
2. Due date has been extended to Friday.

## Introduction 

In this assignment, you will first write some toy programs in the Patina language to get more familiar with the language's syntax. Then, you will build a lexer and a parser to parse well-formed Patina programs into abstract syntax trees.

## Instructions

1. Download the starter code [here](https://github.com/fredfeng/CS160/tree/main/assignments/as2).

2. Unlike Assignment 1, the starter code is no longer individual files, but a self-contained `dune` project. You will need to install `dune` through `opam`:
      
        opam install dune
    
    There is [guide](https://junrui-liu.github.io/patina/setup/setup.html) on how to install `opam` on your machine or CSIL. If you encounter any difficulty installing `opam` or `dune`, please let us know on Slack.

3. The only files you need to modify are `scanner.mll` and `parser.mly`. 

4. A driver program (`patina.ml`) is provided to help you test your lexer/parser. It requires `ppx_deriving.show` for pretty printing, which you can install with `opam install ppx_deriving`. Once you have that, you can run the driver on a Patina source file with
      
        dune exec ./patina.exe -- <filename>


## Submission and Grading
Submit your `scanner.mll` and `parser.mly` to [gradescope](https://www.gradescope.com/courses/322641).

Please make sure that your code compiles before submitting them.

There are 21 tests in total, 16 of which are public. You can find the public tests [here](https://github.com/fredfeng/CS160/tree/main/assignments/as2/tests).

## Part 1

You will write some simple programs in the Patina language. We'll provide you with a [prototype interpreter](https://github.com/fredfeng/CS160/tree/main/assignments/as2/interpreter) for you to validate your programs. Be aware that the prototype is quite crappy; by the end of this course will have a compiler that's much better than ours. Use `patina-darwin` if your machine uses macOS, and `patina-linux` if your machine uses Linux (including CSIL). Run it with `./patina-<your-os> -i <patina-source-file>`.

For each of these, we recommend looking at the [syntax reference](../ref.md) of Patina, as well as the [overview](../overview/overview.md) of Patina in the first section of the page. They should contain all the information that is necessary to complete the assignments. For anything that's unclear after that, ask on Slack!

### Program 1
Write a simple function to practice the oddities of Patina syntax. This function should take an int as argument, create an array with length equal to the integer, fill it with 7s, and then return it. The main function should call this function with 3 as its input and print out the 2nd value in the result.

### Program 2
Let's follow up on the section - write a function that takes in an integer and returns whether or not the integer is a perfect number. You can do so by creating a list of all the factors of the input integer, and then sums them together to check whether a number is perfect or not, returning `true` if it is and `false` otherwise.

In your `main` function, use a while loop to print out perfect numbers up to 1000, each on a new line. For example, if your source file is named `perfect.pt`, then running `./patina-<your-os> -i perfect.pt` should output
```
6
28
496
```


## Part 2

The first step of a compiler is splitting the string of the whole code into pieces which represent all of the important parts. Since Patina has no syntax for comments, this should be straightforward.

Ocaml has the very useful tool for doing lexing of `ocamllex`, which takes a definition of a mapping from token strings to tokens, and produces an automaton that can actually do the lexing. This takes advantage of the insight you've learned in class about how simple enough languages can be parsed with simple automata.

Each of the lines of code will look something like:
```
  | '/'  { DIV }         
```

Each of these tokens is atomic for the purpose of parsing - it can't be divided further without losing some utility. For example, you don't want to make each digit in an integer a separate token, because you'd have to put them all together when parsing any case where they're used. On the other hand, you wouldn't want to count "(2" as a token, because that parenthesis is going to work just as any other parenthesis in the problem.

Fill out the rows of your template `scanner.mll` file to write a lexer for Patina's full syntax.

## Part 3: Parser

Parsing is the central work of this assignment, and the purpose of good lexing is to make parsing easier.

`ocamlyacc` is a tool which automatically generates a parser for a language if you define how it works. You will use it to parse textual file containing Patina programs into their abstract syntax tree representation.

Each line of the parser should be inside of a block defining a non-terminal or terminal symbol, and should include both the symbols that make it up on the left, as well as OCaml code (using the constructors of the AST) which represents the value on the right. This value is _not_ the result of interpretation of the code, so no addition or other calculation should be done.

For example, to say that an expression formed by two sub-expressions separated by the `DIV` token, we write
```
expr:
    ...
    | expr DIV expr      { Binary(Div, $1,$3) }
```

We have defined an abstract syntax tree (AST) type for you in `ast.ml`, but it's up to you do define the intermediate nodes of parsing. You can use the patina concrete reference not only as a reference of how Patina code looks, but also as hints for what parsing structure to use.

Modify the template `parser.mly` file to write a parser for Patina's full syntax. Specifically, you will need to add three kinds of stuff:
1. Since the parser is connected to the lexer your wrote for Part 2, you need to declare in the parser file the tokens you defined in the lexer:
      ```
      %token // TODO: Your tokens here
      ```
2. Define your grammar rules:
      ```
      // TODO: Your rules here E.g.
      ```
3. Your grammar will likely be ambiguous (i.e. there will be shift/reduce or even reduce/reduce conflicts). You can resolve a lot of ambiguities by simply specifying the [precedence and associativity](https://ocaml.org/manual/lexyacc.html#ss:ocamlyacc-declarations) of the elements in your grammar:
      ```
      // TODO: Your associativity rules here
      ```