# Reference Manual

<!-- TODO: For each language construct, describe its
- syntax
- dynamic semantics
- static semantics -->

## Concrete Syntax
```
Program   ::= Function+
Function+ ::= a non-empty list of "Function"
Function  ::= fn ID ( Param* ) -> Type Sequence
Param*    ::= a list of "ID : Type" separated by ","
Type      ::= unit | bool | int | [int]
Sequence  ::= { Expr+ }
Expr+     ::= a non-empty list of "Expr" separated by ";"
Expr      ::= ()
           | true | false 
           | NON_NEG_INT
           | ID
           | ( Expr )
           | - Expr
           | ! Expr
           | Expr ⊕ Expr      ⊕ ∈ { +, -, *, /, &&, ||, ==, !=, >=, >, <=, < }
           | Sequence
           | if Expr then Sequence else Sequence
           | let ID : Type = Expr
           | while Expr Sequence
           | ID [ Expr ]
           | ID = Expr
           | ID [ Expr ] = Expr
           | ID ( Expr* )
Expr*     ::= a list of "Expr" separated by ","

ID          = a letter followed by any number of letters or numbers
```

### Precedence and Associativity
Unary operators have the highest precedence, followed by the arithmetic operators, integer relations, and logical operators, with their usual precedence. That is, multiplication and division have higher precedence than addition and subtraction, and logical conjunction has higher precedence over disjunction.

Operators associate to the left. Relations are non-associative.