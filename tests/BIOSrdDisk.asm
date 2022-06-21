[org 0x7c00] ; Using 0x7c00 as the origin of our data

mov [diskNum], dl ; Making sure the disk read is the same as the disk containing the boot sector

main:
    ; Setting up the disk reading
    mov ah, 2 ; Setting 0x13-interrupt's mode to "read the disk"
    mov al, 1 ; Setting the number of sectors to read
    mov ch, 0 ; Setting the track number
    mov cl, 2 ; Setting the sector number (count start at 1 for this one, not 0)
    mov dh, 0 ; Setting the head we want to read with
    mov dl, [diskNum] ; Setting which disk we want to read from
    mov bx, 0 ; (Used to transfer the value `0` to es. Using bx since it's not set right now)
    mov es, bx ; Not using the extra-segment-pointer since we are not out of bounds reading only one sector
    mov bx, 0x7e00 ; Setting where to put our read sector

    int 0x13 ; Properly calling the BIOS, effectively reading the disk with all the previously set informations

    mov ah, 0x0e ; Resetting so that the next 0x10 interrupt's mode will write in teletype (tty) mode
    mov al, [0x7e00] ; Setting the character to write as the first read in our freshly-read sector

    int 0x10 ; Writing the character with a BIOS interrupt. It should only print "A"

jmp $ ; Ensuring an infinite self-loop

; Variables
diskNum:
    db 0x00

; Filling boot sector
times 510-($-$$) db 0
db 0x55, 0xAA

times 512 db 'A'; Filling the following sector with "A"'s
