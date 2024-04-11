    int $0x20           # Exit to command line.

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

    ret                 # Return to caller.

    # Read keyboard into AL (ASCII code, see appendix B).
read_keyboard:
    pushw %bx
    pushw %cx
    pushw %dx
    pushw %si
    pushw %di

    movb  $0x00, %ah	# Load AH with code for keyboard read.
    int   $0x16         # Call the BIOS for reading keyboard.

    popw  %di
    popw  %si
    popw  %dx
    popw  %cx
    popw  %bx

    ret                 # Return to caller.
