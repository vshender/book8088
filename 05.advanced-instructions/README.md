# Chapter 5: Advanced instructions

## Examples

- [palette.s](palette.s) -- show the VGA palette.
- [mandel.s](mandel.s) -- draw a Mandelbrot set.


## Instructions Learned

1. `adc`, does addition with the Carry flag.
2. `cmpsb`, does comparison of one byte of DS:SI against ES:DI, increment/decrement both SI and DI by 1.
3. `cmpsw`, does comparison of one word of DS:SI against ES:DI, increment/decrement both SI and DI by 2.
4. `cwd`, does expansion of signed value inside AX to a 32-bit value inside DX:AX.
5. `lodsb`, read one byte into AL from DS:SI, increment/decrement SI by 1.
6. `lodsw`, read one word into AX from DS:SI, increment/decrement SI by 2.
7. `movsb`, copy one byte from DS:SI into ES:DI, increment/decrement both SI and DI by 1.
8. `movsw`, copy one word from DS:SI into ES:DI, increment/decrement both SI and ID by 2.
9. `sbb`, does substraction with the Carry flag.
10. `scasb`, does comparison of one byte of AL against ES:DI, increment/decrement DI by 1.
11. `scasw`, does comparison of one word of AX against ES:DI, increment/decrement DI by 2.
12. `xchg`, interchange content of register and register or memory.  It uses a single byte when interchanging AX with any register.
