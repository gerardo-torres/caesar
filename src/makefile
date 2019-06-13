make: 
	nasm -f elf main.asm
	ld -o caesar -m elf_i386 main.o

clean:
	rm *.o && rm caesar