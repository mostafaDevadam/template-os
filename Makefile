OBJECTS = $(BUILD_DIR)/loader.o $(BUILD_DIR)/kmain.o $(BUILD_DIR)/io.o $(BUILD_DIR)/fb.o \
$(BUILD_DIR)/serial.o $(BUILD_DIR)/gdt.o $(BUILD_DIR)/gdt_s.o $(BUILD_DIR)/idt.o $(BUILD_DIR)/idt_s.o \
 $(BUILD_DIR)/keyboard.o $(BUILD_DIR)/shell.o


CC = gcc
CFLAGS = -m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector \
         -nostartfiles -nodefaultlibs -Wall -Wextra -Werror -c
LDFLAGS = -T link.ld -melf_i386
AS = nasm
ASFLAGS = -f elf
BUILD_DIR = build


all: clean $(BUILD_DIR) kernel.elf

kernel.elf: $(OBJECTS)
	ld $(LDFLAGS) $(OBJECTS) -o kernel.elf

hydra.iso: kernel.elf
	cp kernel.elf iso/boot/kernel.elf
	#xorriso -as mkisofs -R \
	genisoimage -R \
	            -b boot/grub/stage2_eltorito \
	            -no-emul-boot \
	            -boot-load-size 4 \
	            -A os \
	            -input-charset utf8 \
	            -quiet \
	            -boot-info-table \
	            -o hydra.iso \
	            iso

run: hydra.iso
	qemu-system-i386 -cdrom hydra.iso

$(BUILD_DIR)/gdt_s.o: gdt_asm.s
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD_DIR)/idt_s.o: idt_asm.s
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD_DIR)/%.o: %.c
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf *.o kernel.elf hydra.iso $(BUILD_DIR)