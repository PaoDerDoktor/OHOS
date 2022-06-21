[org 0x7c00]

mov [bootDisk], dl ; Setting the boot-disk's ID variable

;;;;;;;;;;;;;;;;;;;;
;; REAL MODE CODE ;;
;;;;;;;;;;;;;;;;;;;;

; READING THE DISK TO GET THE KERNEL LOADED

xor ax, ax ; Zero-ing ax by xorr it with itself
mov es, ax ; Setting es (extra-segment pointer) to 0
mov ds, ax ; Setting ds (data-segment pointer) to 0
mov sp, bp ; Setting the stack pointer to the stack's base pointer

mov bx, KERNEL_LOCATION ; Pointer to the buffer in which the kernel will be loaded
mov dh, 20 ; Number of sectors to read

mov ah, 0x02 ; Setting the 0x13-interrupt's mode to read disk sectors

mov al, dh ; Setting the number of sectors to read
mov ch, 0x00 ; We want a sector that is on the first track/cylinder
mov dh, 0x00 ; We want to read with the first head
mov cl, 0x02 ; We want to read from sector just after the boot sector
mov dl, [bootDisk] ; We want to read from the disk we just booted from
int 0x13 ; Launching the interrupt to get sector data

; CLEARING THE SCREEN
mov ah, 0x0 ; Setting the 0x10-interrupt's mode to "Set video mode", which clears the screen
mov al, 0x3 ; Specifying the video mode as "text mode"
int 0x10 ; Changing the video mode

; SWITCHING TO PROTECTED MODE
cli ; Disabling interrupts
lgdt [GDT_Descriptor] ; Specifying the gdt
mov eax, cr0 ; Copying value of special register cr0 to 32-bits register eax to edit it
or eax, 1 ; Raising the least significant bit of cr0's value
mov cr0, eax ; Pushing the value back to cr0

jmp CODE_SEG:start_protected_mode ; Da Far Jump !!

; Kernel-related constants
KERNEL_LOCATION equ 0x1000 ; Location in memory of the loaded kernel
CODE_SEG equ GDT_code - GDT_Start ; Pointer to the Code segment's GDT entry
DATA_SEG equ GDT_data - GDT_Start ; Pointer to the Data segment's GFT entry

; Real-mode variables
bootDisk: ; The ID of the disk from where we booted
    db 0

; GDT Table
GDT_Start:
    GDT_null:
        dd 0x0
        dd 0x0
    
    GDT_code:
        dw 0xffff
        dw 0x0
        db 0x0
        db 0b10011010
        db 0b11001111
        db 0x0
    
    GDT_data:
        dw 0xffff
        dw 0x0
        db 0x0
        db 0b10010010
        db 0b11001111
        db 0x0
GDT_End:

GDT_Descriptor:
    dw GDT_End - GDT_Start - 1
    dd GDT_Start

[bits 32]

;;;;;;;;;;;;;;;;;;;;;;;;;
;; PROTECTED MODE CODE ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

start_protected_mode: ; Executed when firrst entering protected mode
    mov ax, DATA_SEG ; Loading the pointer to the beginning of the data segment
    mov ds, ax ; Setting up special register ds to the right address
    mov ss, ax ; The stack begins at the same place
    mov es, ax ; The extra segment is also at the same place
    mov fs, ax ; The second extra segment too
    mov gs, ax ; And so is the third extra segment
    mov ebp, 0x90000 ; Moving the 32-bits stack base
    mov esp, ebp ; Setting the 32-bits stack pointer accordingly

    jmp KERNEL_LOCATION

; Filling the rest of the boot sector with nulls and magic number 0xaa55
times 510-($-$$) db 0
dw 0xaa55
