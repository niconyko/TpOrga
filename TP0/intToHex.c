#include <stdio.h>
#include <stdlib.h>

void intToHex(int numInt, int* primerNum, int* segundoNum) {
	int highNible = numInt & 0xf0;
	int lowNible = numInt & 0x0f;
	*primerNum = highNible >> 4;
	*segundoNum = lowNible;
}

void numsToChars(int primerNum, int segundoNum, char* primerChar, char* segundoChar) {
	char convTable[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
	*primerChar = convTable[primerNum];
	*segundoChar = convTable[segundoNum];
}

int main(int argc, char **argv) {
	int primerNum, segundoNum;
	char primerChar, segundoChar;
	int numLetra = 'J';
	intToHex(numLetra, &primerNum, &segundoNum);
	//printf("High nib: %d\n", primerNum);
	//printf("Low nib: %d\n", segundoNum);
	numsToChars(primerNum, segundoNum, &primerChar, &segundoChar);
	printf("Numero: %d \n", numLetra);
	printf("HexNumber: %c%c", primerChar, segundoChar);
	return 0;
}

