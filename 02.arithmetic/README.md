# Chapter 2: Arithmetic

## Examples

- [library1.s](library1.s) -- subroutines library.
- [add1.s](add1.s) -- addition example.
- [sub1.s](sub1.s) -- substraction example.
- [mul1.s](mul1.s) -- multiplication example.
- [div1.s](div1.s) -- division example.
- [shift1.s](shift1.s) -- shift example.
- [logical1.s](logical1.s) -- logical and example.
- [inc1.s](inc1.s) -- increment and decrement example.
- [guess.s](guess.s) -- guess the number game.

I include the subroutines library using the [`.include`](https://sourceware.org/binutils/docs/as/Include.html) directive here instead of copying it into the source code of the examples, as is done in the book.


## Instructions learned

1. `add`, addition.
2. `and`, bitwise *and* operation.
3. `call`, call subroutine.
4. `cmp`, comparison.
5. `dec`, decrement.
6. `div`, unsigned integer division.
7. `idiv`, signed integer division.
8. `imul`, signed integer multiplication.
9. `in`, read port.
10. `mul`, unsigned integer multiplication.
11. `neg`, negation.
12. `nop`, no operation.
13. `not`, bitwise *not* operation.
14. `or`, bitwise *or* operation.
15. `rcl`, rotation to left through carry flag.
16. `rcr`, rotation to right through carry flag.
17. `ret`, return from subroutine.
18. `rol`, rotation to left circular.
19. `ror`, rotation to right circular.
20. `sar`, shift arithmetic to right.
21. `shl`/`sal`, shift logical to left, or shift arithmetic to left.
22. `shr`, shift logical to right.
23. `sub`, substraction.
24. `xor`, bitwise *xor* operation.
