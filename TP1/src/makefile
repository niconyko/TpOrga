all: tp1

b16c: b16c.h
	gcc -Wall -c b16c.c

b16S: b16.h
	gcc -Wall -c b16.S

tp1: b16c b16S
	gcc -Wall b16.o b16c.o -o tp1 tp1.c

clean:
	rm b16c.o b16.o tp1
