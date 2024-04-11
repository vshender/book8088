# Guess a number between 0 and 7.
#

    .code16

    .globl start
start:
    inb   $0x40                         # Read the timer counter chip to AL.
    andb  $0x07, %al                    # Mask bits so the value becomes 0-7.
    addb  $0x30, %al                    # Convert into ASCII digit
    movb  %al, %cl                      # Save AL to CL.

game_loop:
    movb  $'?, %al                      # AL now is question-mark sign.
    call  display_letter                # Display.

    call  read_keyboard                 # Read keyboard.
    cmpb  %cl, %al                      # AL equals CL?
    jne   game_loop                     # No, jumps (Jump if Not Equal).

    call  display_letter                # Display number.

    # Display happy face.
    movb  $':, %al
    call  display_letter
    movb  $'), %al
    call  display_letter

    .include "library1.s"
