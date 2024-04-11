# Addition example: 4 + 3 = 7.
#

    .code16

    .globl start
start:
    movb  $0x04, %al                    # Load register AL with 0x04.
    addb  $0x03, %al                    # Add 0x03 to register AL.

    addb  $0x30, %al                    # Convert to ASCII digit.
    call  display_letter

    .include "library1.s"
