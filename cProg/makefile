all: mainC.o tests.o 
	gcc -g -Wall -o calc mainC.o tests.o -lm

mainC.o: mainC.c header.h
	gcc -g -Wall -c -o mainC.o mainC.c

tests.o: header.h
	gcc -g -Wall -c -o tests.o tests.c

.PHONY: clean

clean:
	rm -f *.o calc
