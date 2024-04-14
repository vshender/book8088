# A "Hello, world" program that can be used a inside boot sector.
#

    .code16

    .globl start
start:
    pushw %cs                     # Assumes CS contains 0x0000.
    popw  %ds

    movw  $string, %bx            # Load register BX with address of `string`.

repeat:
    movb  (%bx), %al              # Load a byte in AL from address pointed by BX.
    testb %al, %al                # Test AL for zero.
    jz    end                     # Jump if equal to `end` label (jump if zero).

    pushw %bx                     # Save BX register in stack.
    movb  $0x0e, %ah              # Load AH with code for terminal output.
    movw  $0x000f, %bx            # BH is page zero, BL is color (graphic mode).
    int   $0x10                   # Call the BIOS for displaying one letter.
    popw  %bx                     # Restore BX register from stack.

    incw  %bx                     # Increase BX register by 1 (next letter).
    jmp   repeat                  # Jump to `repeat` label.

end:
    jmp   .                       # Jump over itself (. gives current address).

string:
    .ascii "Hello, world\0"

    .fill 510 - (. - start), 1, 0 # Fill the remaining of boot sector (512 bytes).

    .byte 0x55, 0xaa              # Signature so BIOS detects it as bootable.
