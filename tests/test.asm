[org 0x7c00] ; Putting origin of memory at 0x7c00

mov bx, 0 ; string offset

mov ah, 0x0e      ; Entering TTY mode
mov al, 1

lp: ; string writing loop
    mov al, [toWrite + bx]
    inc bx
    cmp al, 0
    je  lpExit
    int 0x10
    jmp lp

lpExit:


;; Jumping to boot (?)
;booter:
;    jmp $

; Variables
toWrite:
    db "Hey yo this a string, also trans rights", 0

; Creating a boot sector
times 510-($-$$) db 0
db 0x55, 0xaa
