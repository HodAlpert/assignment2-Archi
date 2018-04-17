all: mainC.o
	gcc -g -Wall -o calc mainC.o-lm

mainC.o: mainC.c header.h
	gcc -g -Wall -c -o mainC.o mainC.c

.PHONY: clean

clean:
	rm -f *.o calc
