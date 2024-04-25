# Draw a Mandelbrot set.
#

    .code16

    # Working in VGA 320x200x256 colors
    #
    # 0xfa00 is the first byte of video memory
    # not visible on the screen.

    .equ v_a, 0xfa00            # Y-coordinate
    .equ v_b, 0xfa02            # X-coordinate
    .equ v_x, 0xfa04            # x 32-bit for Mandelbrot 24.8 fraction.
    .equ v_y, 0xfa08            # y 32-bit for Mandelbrot 24.8 fraction.
    .equ v_s1, 0xfa0c           # temporal s1
    .equ v_s2, 0xfa10           # temporal s2

    .globl start
start:
    movw  $0x0013, %ax          # Set mode 320x200x256.
    int   $0x10                 # Video interruption vector.

    movw  $0xa000, %ax          # 0xa000 video segment.
    movw  %ax, %ds              # Setup data segment.
    movw  %ax, %es              # Setup extended segment.

m4:
    movw  $199, %ax             # 199 is the bottommost row.
    movw  %ax, v_a              # Save into v_a.
m0:
    movw  $319, %ax             # 319 is the rightmost column.
    movw  %ax, v_b              # Save into v_b.

m1:
    xorw  %ax, %ax
    movw  %ax, v_x              # x = 0.0.
    movw  %ax, v_x+2
    movw  %ax, v_y              # y = 0.0.
    movw  %ax, v_y+2
    mov   $0, %cx               # Iteration counter.

m2:
    pushw %cx                   # Save counter.
    movw  v_x, %ax              # Read x.
    movw  v_x+2, %dx
    call  square32              # Get x² (x * x).
    pushw %dx                   # Save result to stack.
    pushw %ax
    movw  v_y, %ax              # Read y
    movw  v_y+2, %dx
    call  square32              # Get y² (y * y).

    popw  %bx
    addw  %bx, %ax              # Add both (x² + y²).
    popw  %bx
    adcw  %bx, %dx

    popw  %cx                   # Restore counter.
    cmpw  $0, %dx               # Result is >= 4.0?
    jne   m3
    cmp   $4 * 256, %ax
    jnc   m3                    # Yes, jump.

    pushw %cx
    mov   v_y, %ax              # Read y.
    mov   v_y+2, %dx
    call  square32              # Get y² (y * y).
    pushw %dx
    pushw %ax
    movw  v_x, %ax              # Read x.
    movw  v_x+2, %dx
    call  square32              # Get x² (x * x).

    popw  %bx
    subw  %bx, %ax              # Subtract (x² - y²).
    popw  %bx
    sbb   %bx, %dx

    # Adding x coordinate like a fraction to current value.
    #
    addw  v_b, %ax              # Add x coordinate.
    adcw  $0, %dx
    addw  v_b, %ax              # Add x coordinate
    adcw  $0, %dx
    subw  $480, %ax             # Center coordinate
    sbbw  $0, %dx

    pushw %ax                   # Save result to stack.
    pushw %dx

    movw  v_x, %ax              # Get x.
    movw  v_x+2, %dx
    movw  v_y, %bx              # Get y.
    movw  v_y+2, %cx
    call  mul32                 # Multiply (x * y)

    shlw  $1, %ax               # Multiply by 2.
    rclw  $1, %dx

    addw  v_a, %ax              # Add y coordinate.
    adcw  $0, %dx
    addw  v_a, %ax              # Add y coordinate.
    adcw  $0, %dx

    subw  $250, %ax             # Center coordinate.
    sbbw  $0, %dx

    movw  %ax, v_y              # Save as new y value.
    movw  %dx, v_y+2

    popw  %dx                   # Restore value from stack.
    popw  %ax

    movw  %ax, v_x              # Save as new x value.
    movw  %dx, v_x+2

    popw  %cx
    incw  %cx                   # Increase iteration counter.
    cmpw  $100, %cx             # Attempt 100?
    je    m3                    # Yes, jump.
    jmp   m2                    # No, continue.

m3:
    movw  v_a, %ax              # Get Y-coordinate.
    movw  $320, %dx             # Multiply by 320 (size of pixel row).
    mulw  %dx
    addw  v_b, %ax              # Add X-coordinate to result.
    xchgw %ax, %di              # Pass AX to DI.

    addb  $0x20, %cl            # Index counter into rainbow colors.
    movb  %cl, (%di)            # Put pixel on the screen.

    decw  v_b                   # Decrease column.
    jns   m1                    # Is it negative?  No, jump.

    decw  v_a                   # Decrease row.
    jns   m0                    # Is it negative?  No, jump.

    movb  $0x00, %ah            # Wait for a key.
    int   $0x16                 # Keyboard interruption vector..

    mov   $0x0002, %ax          # Set mode 80x25 text.
    int   $0x10                 # Video interruption vector.

    int   $0x20                 # Exit to command-line.

    # Calculate a squared number
    # DX:AX = (DX:AX * DX:AX) / 256
    #
square32:
    # Copy multiplicand to multiplier
    movw  %ax, %bx              # Copy AX -> BX.
    movw  %dx, %cx              # Copy DX -> CX.

    # 32-bit signed fractional multiplication
    # DX:AX = (DX:AX * CX:BX) / 256
    #
mul32:
    xorw  %cx, %dx              # Look for different signs.
    pushf
    xorw  %cx, %dx              # Restore DX (pair of XOR = unaffected).
    jns   mul32_2               # If multiplicand is positive then jump.
    notw  %ax                   # Negate multiplicand.
    not   %dx
    addw  $1, %ax
    adcw  $0, %dx
mul32_2:
    test  %cx, %cx              # Test if multiplier is positive.
    jns   mul32_3               # Is it positive?  Yes, jump.
    notw  %bx                   # Negate multiplier.
    not   %cx
    addw  $1, %bx
    adcw  $0, %cx
mul32_3:
    movw  %ax, v_s1             # Save multiplicand (S1).
    movw  %dx, v_s1+2

    # In this diagram each point and letter is a word.
    #    . = not calculated
    #    + = calculated
    #    A = AX value
    #    B = multiplier
    #    C = result
    # rightmost column of result goes into v_s2
    # next to last goes into v_s2+2
    # next into v_s2+4

    #       .A
    #     x .B
    #     ----
    #       .C
    #      ..
    mulw  %bx                   # S1:low * BX = DX:AX.
    movw  %ax, v_s2             # Save provisional result.
    movw  %dx, v_s2+2

    #       A.
    #     x B.
    #     ----
    #       .+
    #      C.
    movw  v_s1+2, %ax           # S1:high * CX = DX:AX.
    mulw  %cx
    movw  %ax,v_s2+4            # Save next word of result.
                                # Notice it doesn't need DX.

    #       A.
    #     x .B
    #     ----
    #       C+
    #      +.
    movw  v_s1+2, %ax           # S1:high * BX = DX:AX.
    mulw  %bx
    addw  %ax, v_s2+2           # Adds to previous result.
    adcw  %dx, v_s2+4

    #       .A
    #     x B.
    #     ----
    #       ++
    #      +C
    movw  v_s1, %ax             # S1:low * CX = DX:AX.
    mulw  %cx
    addw  %ax, v_s2+2           # Adds to previous result.
    adcw  %dx, v_s2+4

    movw  v_s2+1, %ax           # Reads result shifted by 1 byte.
    movw  v_s2+3, %dx           # equivalent to divide by 256.

    popf                        # Restore flags
    jns   mul32_1               # Different signs?  No, jump.
    notw  %ax                   # Negate result.
    notw  %dx
    addw  $1, %ax
    adcw  $0, %dx

mul32_1:
    ret                         # Return.
