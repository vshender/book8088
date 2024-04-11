# Logical and example: 0x32 & 0x0f = 2.
#

    .code16

    .globl start
start:
    movb  $0x32, %al                 # Load register AL with 0x32 (50 decimal).
    andb  $0x0f, %al                 # Logical AND AL with 0x0f.

    addb  $0x30, %al                 # Convert to ASCII digit.
    call  display_letter

    .include "library1.s"
