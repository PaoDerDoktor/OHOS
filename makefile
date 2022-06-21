CC = i386-elf-g++ # Using C++ cross-compiler
CPP_FLAGS = -ffreestanding -m32 -g -c -Iinclude

CASM = nasm
ASM_FLAGS = -f bin

LD = i386-elf-ld
LD_FLAGS = -Ttext 0x1000 --oformat binary

ODIR = build
SRCDIR = src


all: directories $(ODIR)/OS.bin

directories:
	@mkdir -p $(ODIR)
	@mkdir -p $(ODIR)/datastructures
	@mkdir -p $(ODIR)/io

$(ODIR)/OS.bin: $(ODIR)/everything.bin $(ODIR)/stuff_disk.bin
	@cat $(ODIR)/everything.bin $(ODIR)/stuff_disk.bin > $(ODIR)/OS.bin

$(ODIR)/everything.bin: $(ODIR)/boot.bin $(ODIR)/full_kernel.bin
	@cat $(ODIR)/boot.bin $(ODIR)/full_kernel.bin > $(ODIR)/everything.bin

$(ODIR)/boot.bin:
	@$(CASM) $(SRCDIR)/bootLoader.asm $(ASM_FLAGS) -o $(ODIR)/boot.bin

$(ODIR)/full_kernel.bin: $(ODIR)/kernel_entry.o $(ODIR)/kernel.o $(ODIR)/datastructures/string.o $(ODIR)/io/printing.o
	@$(LD) $(LD_FLAGS) $(ODIR)/kernel_entry.o $(ODIR)/kernel.o $(ODIR)/datastructures/string.o $(ODIR)/io/printing.o -o $(ODIR)/full_kernel.bin

$(ODIR)/kernel_entry.o:
	@$(CASM) $(SRCDIR)/kernel_entry.asm -f elf -o $(ODIR)/kernel_entry.o

$(ODIR)/kernel.o: 
	@$(CC) $(CPP_FLAGS) $(SRCDIR)/kernel.cpp -o $(ODIR)/kernel.o
	
$(ODIR)/stuff_disk.bin:
	@$(CASM) $(SRCDIR)/stuff_disk.asm $(ASM_FLAGS) -o $(ODIR)/stuff_disk.bin

$(ODIR)/datastructures/string.o:
	@$(CC) $(CPP_FLAGS) $(SRCDIR)/datastructures/string.cpp -o $(ODIR)/datastructures/string.o

$(ODIR)/io/printing.o:
	@$(CC) $(CPP_FLAGS) $(SRCDIR)/io/printing.cpp -o $(ODIR)/io/printing.o

clean: # Just removing output directory
	@rm -rf $(ODIR)/*
