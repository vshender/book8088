# Multiplication example: 3 * 2 = 6.
#

    .code16

    .globl start
start:
     movb  $0x03, %al                   # Load register AL with 0x03.
     movb  $0x02, %cl                   # Load register CL with 0x02.
     mulb  %cl                          # Multiply AL by CL, result into AX.

     addb  $0x30, %al                   # Convert to ASCII digit.
     call  display_letter

     .include "library1.s"
