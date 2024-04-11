# Division example: 100 / 33 = 3.
#

    .code16

    .globl start
start:
    movw  $0x64, %ax          # Load register AX with 0x64 (100 decimal).
    movb  $0x21, %cl          # Load register CL with 0x21 (33 decimal).
    divb  %cl                 # Divide AX by CL, result -> AL, remainder -> AH.

    addb  $0x30, %al          # Convert to ASCII digit.
    call  display_letter

    .include "library1.s"
