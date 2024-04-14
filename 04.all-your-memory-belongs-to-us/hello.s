# Example of direct access to text-mode memory.
#

    .code16

    .globl start
start:
    # Setup text 80x25 mode color.
    movw  $0x0002, %ax        # AH = 0x00 set mode, AL = 0x02 80x25x16 text.
    int   $0x10

    # Set segment registers for data to 0xb800 -- start of color text mode
    # memory.
    movw  $0xb800, %ax
    movw  %ax, %ds
    movw  %ax, %es

    # Output message writing to screen memory.
    cld                       # Clear the direction flag.

    xorw  %di, %di

    movw  $0x1a48, %ax        # 'H', blue background, light green foreground.
    stosw                     # Write AX to ES:DI and increment DI by 2.
    movw  $0x1b45, %ax        # 'E', blue background, ligth aqua foreground.
    stosw                     # Write AX to ES:DI and increment DI by 2.
    movw  $0x1c4c, %ax        # 'L', blue background, light red foreground.
    stosw                     # Write AX to ES:DI and increment DI by 2.
    movw  $0x1d4c, %ax        # 'O', blue background, light purple foreground.
    stosw                     # Write AX to ES:DI and increment DI by 2.
    movw  $0x1e4f, %ax        # 'O', blue background, light yello foreground.
    stosw                     # Write AX to ES:DI and increment DI by 2.

    int   $0x20               # Exit to command-line.
