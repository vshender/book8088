# Chapter 4: All your memory belongs to us

## Examples

- [hello.s](hello.s) -- example of direct access to text-mode memory.
- [circles.s](circles.s) -- colorful circles.
- [boot.s](boot.s) -- "Hello, world" program that can be used inside boot sector.

  Test the image using [QEMU](https://www.qemu.org/):
  ```
  $ qemu-system-x86_64 -fda boot.img
  ```

## Instructions learned

1. `cld`, clear direction flag.
2. `lds`, load register and DS register.
3. `les`, load register and ES register.
4. `sed`, set direction flag.
5. `stosb`, store AL into ES:DI address.  Increase DI by 1 (if direction flag is zero) or decrease DI by 1 (if direction flag is one).
6. `stosw`, store AX into ES:DI address.  Increase DI by 2 (if direction flag is zero) or decrease DI by 2 (if direction flag is one).
