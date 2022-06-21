[org 0x7c00]

; Printing prompt
mov ah, 0x0E
mov al, ">"
int 0x10

; Ensuring parrot is 30-null
mov bx, [parrot]
nullifyLoop:
    cmp bx, 29
    jg nullifyExit
    mov byte [bx], 0
    inc bx
    jmp nullifyLoop
nullifyExit:

; Preparing data
mov bx, [parrot] ; Points to the next empty parrot index
mov ax, 0x0000 ; Interrupts



; Main loop
main:
    ; Getting currently pressed key
    mov ah, 0x00
    int 0x16
    mov [currentKey], al

    ; Check if the character is a newline
    cmp byte [currentKey], 0x0D
    je printParrot

    ; Check if the character is any other printable character
    cmp byte al, 0x20
    jl main ; If not, loop to main
    ; If yes, print it on the prompt line and save it in the buffer
    mov ah, 0x0E
    mov al, [currentKey]
    int 0x10
    mov byte [bx], al
    inc bx ; Move pointer to next null slot

    jmp main


; Routines
printParrot: ; Prints content of the parrot buffer
    ; Initialize by putting bx at the start of the buffer
    mov bx, [parrot]
    ; Then, preparing the repeat line
    mov ah, 0x0E
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    mov al, [repeatPrompt]
    int 0x10
    printParrotLoop:
        cmp byte [bx], 0 ; If current character is null, stopping and going to the exit
        je printParrotLoopOut
        ; Else, printing current pointed character and replacing it by a null one
        mov ah, 0x0E
        mov al, [bx]
        int 0x10
        mov byte [bx], 0
        inc bx
        jmp printParrotLoop
    printParrotLoopOut:
        ; Resetting bx, preparing next prompt
        mov bx, [parrot]
        mov ah, 0x0E
        mov al, 0x0D
        int 0x10
        mov al, 0x0A
        int 0x10
        mov al, [prompt]
        int 0x10

        jmp main

; Buffers / variables
prompt: ; First character that should be used to prompt the user for input
    db ">"

repeatPrompt: ; First character that should be printed when repeating
    db "@"

currentKey: ; Most recently pressed key
    db 0

parrot: ; Buffer used to repeat
    times (30) db 0


; Creating a boot sector
times 510-($-$$) db 0
db 0x55, 0xaa
