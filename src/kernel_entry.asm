[bits 32] ; We're at this point supposed to be in protected mode
[extern main] ; Getting the extern C/C++ main function

call main ; Call the imported C/C++ main function

jmp $ ; Looping to self indefinitely
