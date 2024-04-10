# The incredible keyboard reading program.
#

    .code16

    .global start
start:
    movb  $0x00, %ah             # Keyboard read.
    int   $0x16                  # Call the BIOS to read it.

    cmpb  $0x1b, %al             # ESC key pressed?
    je    exit_to_command_line

    movb  $0x0e, %ah             # Load AH with code for terminal output.
    movw  $0x000f, %bx           # BH is page zero, BL is color (graphic mode).
    int   $0x10                  # Call the BIOS for displaying one letter.
    jmp   start

exit_to_command_line:
    int   $0x20
