# Sieve of Eratosthenes.
#

    .code16

    .equ table, 0x8000  # An arbitrary address that doesn't collide with our code.
    .equ table_size, 1000

    .globl start
start:
    # Initialize the table to zero.
    movw  $table, %bx
    movw  $table_size, %cx
p1:
    movb  $0, (%bx)         # Write AL into the address pointed by BX.
    incw  %bx               # Increase BX.
    loop  p1                # Decrease CX, jump if non-zero.

    movw  $2, %ax           # Start at number 2.
p2:
    movw  $table, %bx       # BX = table address.
    addw  %ax, %bx          # BX = BX + AX.
    cmpb  $0, (%bx)         # Is it prime?
    jne   p3

    # Number in AX is prime, display it.
    pushw %ax
    call  display_number
    movb  $',, %al
    call  display_letter
    popw  %ax

    # Mark all multipliers as non-prime.
    movw  $table, %bx
    addw  %ax, %bx
p4:
    addw  %ax, %bx
    cmpw  $table + table_size, %bx
    jae   p3
    movb  $1, (%bx)
    jmp   p4

p3:
    # Number in AX is not prime.
    incw  %ax
    cmpw  $table_size, %ax
    jne   p2

    int $0x20               # Exit to command line.

    # Display letter contained in AL (ASCII code, see appendix B).
display_letter:
    pushw %ax
    pushw %bx
    pushw %cx
    pushw %dx
    pushw %si
    pushw %di

    movb  $0x0e, %ah    # Load AH with code for terminal output.
    movw  $0x000f, %bx  # Load BH with page zero and BL with color (only graphic mode).
    int   $0x10         # Call the BIOS for displaying one letter.

    popw  %di
    popw  %si
    popw  %dx
    popw  %cx
    popw  %bx
    popw  %ax

    ret                     # Return to caller.

    # Display the value of AX as a decimal number.
display_number:
    movw  $0, %dx           # Makes dx = 0.
    movw  $10, %cx          # Makes cx = 10.
    divw  %cx               # AX = DX:AX / CX.

    pushw %dx

    cmpw  $0, %ax           # If AX is zero...
    je    display_number_1  # ... jump
    call  display_number                # else calls itself

display_number_1:
    popw  %ax
    addb  $'0, %al          # Convert remainder to ASCII digit
    call  display_letter    # Display in screen.

    ret
