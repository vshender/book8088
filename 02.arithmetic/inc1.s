# Increment and decrement example.
#

    .code16

    .globl start
start:
    movb  $0x30, %al

count1:
    call  display_letter

    incb  %al
    cmpb  $0x39, %al
    jne   count1

count2:
    call  display_letter

    decb  %al
    cmpb  $0x30, %al
    jne   count2

    .include "library1.s"
