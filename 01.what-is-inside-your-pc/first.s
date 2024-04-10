# The incredible "Hello, World" program.
#

    .code16

    .global start
start:
    movw  $string, %bx           # Load register BX with address of `string`.

repeat:
    movb  (%bx), %al             # Load a byte in AL from address pointed by BX.
    testb %al, %al               # Test AL for zero.
    je    end                    # Jump if equal to `end` label (jump if zero).

    pushw %bx                    # Save BX register in stack.
    movb  $0x0e, %ah             # Load AH with code for terminal output.
    movw  $0x000f, %bx           # BH is page zero, BL is color (graphic mode).
    int   $0x10                  # Call the BIOS for displaying one letter.
    popw  %bx                    # Restore BX register from stack.

    incw  %bx                    # Increase BX register by 1 (next letter).
    jmp   repeat                 # Jump to `repeat` label.

end:
    int   $0x20                  # Exit to command-line.

string:
    .ascii "Hello, world\0"
