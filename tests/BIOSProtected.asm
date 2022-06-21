[org 0x7c00]

mov [bootDisk], dl

; Defining constants
CODE_SEG equ code_descriptor - GDT_Start ; Pointer to the code segment
DATA_SEG equ data_descriptor - GDT_Start ; Pointer to the data segment

; Just using the interrupt one last time
mov ah, 0x0e
mov al, 'K'
int 0x10

; Switching to protected mode
cli ; Disable every interrupts
lgdt [GDT_Descriptor] ; Load the GDT
mov eax, cr0 ; Moving current value of special register cr0 to 32-bit register eax ("Extended AX")
or eax, 0x0001 ; Raising the last bit with a bitwise "or" operation
mov cr0, eax ; Putting the modified value back in special register cr0

; Doing the Far Jump
jmp CODE_SEG:start_protected_mode

; GDT table
GDT_Start:
    null_descriptor:
        dd 0 ; four times 00000000
        dd 0 ; four times 00000000
    code_descriptor:
        dw 0xffff ; 2 first bytes of the imit (0xffff)
        
        dw 0 ; 16 +
        db 0 ;  8   = first 24 bits of base (0b000000000000000000000000)

        db 0b10011010 ; Defining the p-p-t properties (4 leftmost bits) and then the type flags

        db 0b11001111 ; Defining the other flags (4 leftmost bits) and then the last 4 bits of the limit ~> Base is now 0xfffff

        db 0 ; Last 8 bits of the base ~> Base is now 0x0000
    data_descriptor:
        dw 0xffff ; 2 first bytes of the imit (0xffff)
        
        dw 0 ; 16 +
        db 0 ;  8   = first 24 bits of base (0b000000000000000000000000)

        db 0b10010010 ; Defining the p-p-t properties (4 leftmost bits) and then the type flags

        db 0b11001111 ; Defining the other flags (4 leftmost bits) and then the last 4 bits of the limit ~> Base is now 0xfffff

        db 0 ; Last 8 bits of the base (0b00000000) ~> Base is now 0x0000
GDT_End:

GDT_Descriptor:
    dw GDT_End - GDT_Start - 1 ; Size of the GDT
    dd GDT_Start ; Pointer to the start of the GDT

[bits 32] ; Ensuring 32 bits mode
start_protected_mode:
    ; So long-e, real mod-er !

    ; Now we'll be printing a character on screen without any interrupt as they are disabled (directly to video memory)

    ; Video memory starts at 0xb8000
    ; Video memory format is, byte-by-byte : [Character, Color]

    mov al, 'A' ; Character to print will be 'A'
    mov ah, 0x0f ; Color with which the character will be printed will be white on black, as usual

    mov [0xb8000], ax ; Move the whole 16 bits to the video memory

    ; Now trying some other color code

    mov ah, 0x1d
    mov [0xb8002], ax ; Should be printed side-by-side

    jmp $

bootDisk:
    db 0

times 510-($-$$) db 0
db 0x55, 0xAA
