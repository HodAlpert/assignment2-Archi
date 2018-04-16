all: main.o mainC.o tests.o
	gcc -g -Wall -o calc main.o mainC.o -lm

main.o: main.s mainC.o header.h
	nasm -g -f elf64 -w+all -o main.o main.s

mainC.o: mainC.c header.h
	gcc -g -Wall -c -o mainC.o mainC.c

tests.o:
	gcc -g -Wall -c -o tests.o tests.c
.PHONY: clean

clean:
	rm -f *.o calc
