all: tp1

b16: b16.h
	gcc -Wall -c b16.S

tp1: b16
	gcc -Wall b16.o -o tp1 tp1.c

clean:
	rm b16.o tp1
