all: main.o tests.o 
	gcc -g -Wall -o calc main.o tests.o -lm

main.o: main.c header.h
	gcc -g -Wall -c -o main.o main.c

tests.o: header.h
	gcc -g -Wall -c -o tests.o tests.c

.PHONY: clean

clean:
	rm -f *.o calc
