all: main.o mainC.o
	gcc -g -Wall -o calc main.o mainC.o -lm

mainC.o: mainC.c header.h
	gcc -g -Wall -c -o mainC.o mainC.c

main.o: main.s header.h
	nasm -g -f elf64 -w+all -o main.o main.s

.PHONY: clean

clean:
	rm -f *.o calc
