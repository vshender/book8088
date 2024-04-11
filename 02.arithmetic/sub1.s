# Substraction example: 4 - 3 = 1.
#

    .code16

    .globl start
start:
    movb  $0x04, %al                    # Load register AL with 0x04.
    subb  $0x03, %al                    # Substract 0x03 from register AL.

    addb  $0x30, %al                    # Convert to ASCII digit.
    call  display_letter

    .include "library1.s"
