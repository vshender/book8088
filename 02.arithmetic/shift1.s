# Shift example: 2 << 1 = 4.
#

    .code16

    .globl start
start:
    movb  $0x02, %al                    # Load register AL with 0x02.
    shlb  $1, %al                       # Shift AL left by one bit.

    addb  $0x30, %al                    # Convert to ASCII digit.
    call  display_letter

    .include "library1.s"
