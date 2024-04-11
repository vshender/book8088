# Tic-Tac-Toe.
#

    .code16

    .equ board, 0x0300

    .globl start
start:
    # Initialize board.
    movw  $board, %bx     # Put address of game board in BX.
    movw  $9, %cx         # Count 9 squares.
    movb  $'1, %al        # Setup AL to contain 0x31 (ASCII code for 1).
b09:
    movb  %al, (%bx)      # Save AL into the square (one byte).
    incb  %al             # Increase AL, this gives us next digit.
    incw  %bx             # Increase direction.
    loop  b09             # Decrement CX, jump if non-zero.

    # Game loop.
b10:
    call  show_board      # Show board.

    call  find_line       # Try to find line.

    call  get_movement    # Get movement.
    movb  $'X, (%bx)      # Put X into square.

    call  show_board      # Show board.

    call  find_line       # Try to find line.

    call  get_movement    # Get movement.
    movb  $'O, (%bx)      # Put O into square.

    jmp   b10

show_board:
    # Show first row.
    movw  $board, %bx
    call  show_row
    call  show_div

    # Show second row.
    movw  $board + 3, %bx
    call  show_row
    call  show_div

    # Show third row.
    movw  $board + 6, %bx
    jmp   show_row        # RET will be called in show_row.

show_row:
    call  show_square
    movb  $'|, %al
    call  display_letter
    call  show_square
    movb  $'|, %al
    call  display_letter
    call  show_square
show_crlf:
    movb  $'\r, %al       # Carriage Return.
    call  display_letter
    movb  $'\n, %al       # Line Feed.
    jmp   display_letter  # RET will be called in display_letter.

show_div:
    movb  $'-, %al
    call  display_letter
    movb  $'+, %al
    call  display_letter
    movb  $'-, %al
    call  display_letter
    movb  $'+, %al
    call  display_letter
    movb  $'-, %al
    call  display_letter
    jmp   show_crlf       # RET will be called in show_crlf.

show_square:
    movb  (%bx), %al      # Get square content.
    inc   %bx             # Point BX to next square.
    jmp   display_letter  # Show square content.

get_movement:
    call  read_keyboard
    cmpb  $0x1b, %al      # Esc key pressed?
    je    do_exit         # Yes, exit.

    subb  $'1, %al        # Subtract code for ASCII digit 1.
    jc    get_movement    # Is it less than?  Wait for another key.
    cmpb  $9, %al         # Comparison with 9.
    jae   get_movement    # Is it greater than or equal to?  Wait for another key.

    cbw                   # Expand AL to 16 bits using AH.
    movw  $board, %bx     # BX points to board.
    addw  %ax, %bx        # Add the key entered.
    movb  (%bx), %al      # Get square content.
    cmpb  $'9, %al        # Comparison with 0x39 (ASCII digit 9).
    ja    get_movement    # Is it greater than?  Wait for another key.
    call  show_crlf       # Line change.
    ret                   # Return, now BX points to square.

do_exit:
    int   $0x20           # Exit to command-line.

find_line:
    # First horizontal row.
    movb  board, %al      # X.. ... ...
    cmpb  board + 1, %al  # .X. ... ...
    jne   b01
    cmpb  board + 2, %al  # ..X ... ...
    je    won
b01:
    # Leftmost vertical row.
    cmpb  board + 3, %al  # ... X.. ...
    jne   b04
    cmpb  board + 6, %al  # ... ... X..
    je    won
b04:
    # First diagonal.
    cmpb  board + 4, %al  # ... .X. ...
    jne   b05
    cmpb  board + 8, %al  # ... ... ..X
    je    won
b05:
    # Second horizontal row.
    movb  board + 3, %al  # ... X.. ...
    cmpb  board + 4, %al  # ... .X. ...
    jne   b02
    cmpb  board + 5, %al  # ... ..X ...
    je    won
b02:
    # Third horizontal row.
    movb  board + 6, %al  # ... ... X..
    cmpb  board + 7, %al  # ... ... .X.
    jne   b03
    cmpb  board + 8, %al  # ... ... ..X
    je    won
b03:
    # Middle vertial row.
    movb  board + 1, %al  # .X. ... ...
    cmpb  board + 4, %al  # ... .X. ...
    jne   b06
    cmpb  board + 7, %al  # ... ... .X.
    je    won
b06:
    # Rightmost vertical row.
    movb  board + 2, %al  # ..X ... ...
    cmpb  board + 5, %al  # ... ..X ...
    jne   b07
    cmpb  board + 8, %al  # ... ... ..X
    je    won
b07:
    # Second diagonal.
    cmpb  board + 4, %al  # ... .X. ...
    jne   b08
    cmpb  board + 6, %al  # ... ... X..
    je    won
b08:
    ret

won:
    # At this point AL contains the letter which made the line.
    call  display_letter
    movb  $' , %al
    call  display_letter
    movb  $'w, %al
    call  display_letter
    mov   $'i, %al
    call  display_letter
    movb  $'n, %al
    call  display_letter
    movb  $'s, %al
    call  display_letter
    int   $0x20

    # Display letter contained in AL (ASCII code, see appendix B).
display_letter:
    pushw %ax
    pushw %bx
    pushw %cx
    pushw %dx
    pushw %si
    pushw %di

    movb  $0x0e, %ah     # Load AH with code for terminal output.
    movw  $0x000f, %bx   # Load BH with page zero and BL with color (only graphic mode).
    int   $0x10          # Call the BIOS for displaying one letter.

    popw  %di
    popw  %si
    popw  %dx
    popw  %cx
    popw  %bx
    popw  %ax

    ret                  # Return to caller.

    # Read keyboard into AL (ASCII code, see appendix B).
read_keyboard:
    pushw %bx
    pushw %cx
    pushw %dx
    pushw %si
    pushw %di

    movb  $0x00, %ah	 # Load AH with code for keyboard read.
    int   $0x16          # Call the BIOS for reading keyboard.

    popw  %di
    popw  %si
    popw  %dx
    popw  %cx
    popw  %bx

    ret                  # Return to caller.
