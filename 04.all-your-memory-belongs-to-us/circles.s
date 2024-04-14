# Colorful circles.
#

    .code16

    .globl start
start:
    movw  $0x0002, %ax                # Setup text 80x25 mode color.
    int   $0x10                       # Call BIOS.

    movw  $0xb800, %ax                # Segment for video data
    movw  %ax, %ds                    # ... load into DS.
    movw  %ax, %es                    # ... load into ES.

    # Main loop.
main_loop:
    # We need a number increasing from 0x00 to 0x3f (63) and then going back to
    # 0x00.
    movb  $0x00, %ah                  # Service to read clock.
    int   $0x1a                       # Call BIOS.
    movb  %dl, %al                    # Save low byte of number of ticks to AL.
    testb $0x40, %al                  # Bit 6 is 1?
    jz    m2                          # No, jump.
    not   %al                         # Complement bits for reverse effect.
m2:
    andb  $0x3f, %al                  # Separate lower 6 bits.
    subb  $0x20, %al                  # Make it -32 to +31.
    cbw                               # Extend to word.
    movw  %ax, %cx                    # Save in CX.

    movw  $0x0000, %di                # Point to the screen.
    movb  $0, %dh                     # Row.
m0: movb  $0, %dl                     # Column.
m1: pushw %dx                         # Save DX (DH and DL).
    movw  $sin_table, %bx

    movb  %dh, %al                    # Take the row.
    shlb  $1, %al                     # Multiply by 2 (because aspect ratio).
    andb  $0x3f, %al                  # Limit to 0-63.
    xlat  %cs:(%bx)                   # Extract sin value.
    cbw                               # Extend to 16 bits.
    pushw %ax                         # Save in stack.

    movb  %dl, %al                    # Take the column.
    andb  $0x3f, %al                  # Limit to 0-63.
    xlat  %cs:(%bx)                   # Extract sin value.
    cbw                               # Extend to 16 bits.

    popw  %dx
    addw  %dx, %ax                    # Add with previous sin.
    addw  %cx, %ax                    # Add with clock time.
    movb  %al, %ah                    # Use as color background/foreground.
    movb  $'*, %al                    # Use asterisk as letter.
    movw  %ax, (%di)                  # Put in display (word).
    addw  $2, %di                     # Go to next letter (word).

    popw  %dx                         # Restore DX.
    incb  %dl                         # Increment column.
    cmpb  $80, %dl                    # Reached 80 columns?
    jne   m1                          # No, jump.

    incb  %dh                         # Increment row.
    cmpb  $25, %dh                    # Reached 25 rows?
    jne   m0                          # No, jump.

    movb  $0x01, %ah                  # BIOS service.  Get keyboard state.
    int   $0x16                       # Call BIOS.
    jne   key_pressed                 # Jump if key pressed.
    jmp   main_loop                   # Repeat.

key_pressed:
    int   $0x20                       # Exit to command-line.

    # Sin table of 360 degrees in 64 bytes.
    # Also -1.0 is -64 and +1.0 is 64.
sin_table:
    .byte   0,   6,  12,  19,  24,  30,  36,  41
    .byte  45,  49,  53,  56,  59,  61,  63,  64
    .byte  64,  64,  63,  61,  59,  56,  53,  49
    .byte  45,  41,  36,  30,  24,  19,  12,   6
    .byte   0,  -6, -12, -19, -24, -30, -36, -41
    .byte -45, -49, -53, -56, -59, -61, -63, -64
    .byte -64, -64, -63, -61, -59, -56, -53, -49
    .byte -45, -41, -36, -30, -24, -19, -12,  -6
