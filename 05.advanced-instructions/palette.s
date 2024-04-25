# Show the VGA palette.
#

    .code16

    # Memory screen uses 64000 pixels,
    # this means 0xfa00 is the first byte of
    # memory not visible on the screen.

    .equ v_a, 0xfa00
    .equ v_b, 0xfa02

    .globl start
start:
    movw  $0x0013, %ax          # Set mode 320x200x256.
    int   $0x10                 # Video interruption vector.

    movw  $0xa000, %ax          # 0xa000 video segment.
    movw  %ax, %ds              # Setup data segment.
    movw  %ax, %es              # Setup extended segment.

m4:
    movw  $127, %ax             # 127 as row.
    movw  %ax, v_a              # Save into v_a.
m0:
    movw  $127, %ax             # 127 as column.
    movw  %ax, v_b              # Save into v_b.

m1:
    movw  v_a, %ax              # Get Y-coordinate.
    movw  $320, %dx             # Multiply by 320 (size of pixel row).
    mulw  %dx
    addw  v_b, %ax              # Add X-coordinate to result.
    xchgw %ax, %di              # Pass AX to DI.

    movw  v_a, %ax              # Get current Y-coordinate.
    # The following two instructions have the same effect as doing division by
    # 8 and multiplication by 16, in order to have a palette index in steps of
    # 16.
    andw  $0x78, %ax            # Separate 4 bits = 16 rows.  0x78 = 0b1111000.
    addw  %ax, %ax              # Value between 0x00 and 0xf0.

    movw  v_b, %bx              # Get current X-coordinate.
    # The following two instructions have the same effect as doing division by
    # 8, in order to get a value between 0x00 and 0x0f.
    movb  $3, %cl               # Shift right by 3 places.
    shrw  %cl, %bx
    addw  %bx, %ax              # Combine with previous value.

    stosb                       # Write AL into address pointed by DI.

    decw  v_b                   # Decrease column.
    jns   m1                    # Is it negative?  No, jump.

    decw  v_a                   # Decrease row.
    jns   m0                    # Is it negative?  No, jump.

    movb  $0x00, %ah            # Wait for a key.
    int   $0x16                 # Keyboard interruption vector.

    movw  $0x0002, %ax          # Set mode 80x25 text.
    int   $0x10                 # Video interruption vector.

    int   $0x20                 # Exit to command line.
