
Template OS for helping to build custom OS
It's customize and copy from Hydra-os.


run:
make run

files:\
iso/boot/: kernel.elf, grub/menu.lst, stage2_eltorito\
gdt(.c,.h,.s)
idt(.c,.h,.s)
io(.h,.s)
fb(.c,.h)
keyboard(.c,.h)
serial(.c,.h)
link.ld
loader.s
kmain.c
Makefile
shell(.c,.h)



using files:
idt: use io.h, serial.h
fb: use io.h
serial: use io.h
keyboard: use serial.h
shell: use fb.h, keyborad.h, serial.h
