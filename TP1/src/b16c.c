#include "b16c.h"
#include <unistd.h>
#include "b16.h"
const char* b16_errmsg[] = {"Error al leer el archivo de entrada\n",
							"Error al escribir el archivo de salida\n",
							"Contiene caracteres que no pertenecen al codigo Hexa\n"};

/*
// ****************************** ENCODE *******************************
static char vecHexa [] = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};

void byte_encoder (char* valorHexa, unsigned int numInt) {
	int highNible = numInt & 0xf0;
	int lowNible = numInt & 0x0f;
	int primerNum = highNible >> 4;
	int segundoNum = lowNible;
	
	valorHexa[0] = vecHexa[primerNum];
	valorHexa[1] = vecHexa[segundoNum];
}

int encode (int infd, int outfd) {
	int caracter = 0;
	ssize_t bytes = read(infd, &caracter, 1);
	if (bytes < 0) bytes = 0 - ERROR_CONST;
	
	while (bytes > 0) {
		char string[2];
		byte_encoder (string, caracter);
		if (write(outfd, string, 2) < 0) bytes = 1 - ERROR_CONST; // error escritura
		else {
			bytes = read(infd, &caracter, 1);
			if (bytes < 0) bytes = 0 - ERROR_CONST;
		}
	}
	return bytes;
}
*/
// ****************************** DECODE *******************************
int correrReferencia  (int numInt) {
	if ( numInt > 47 && numInt < 58)
		return numInt - 48 ;
	
	else if ( numInt > 64 && numInt < 71)
		return numInt - 55 ;
	
	else if ( numInt > 96 && numInt < 103)
		return numInt - 87 ;
	else {
		return 2 - ERROR_CONST; // caracteres no hexa
	}
}

int byte_decoder (int numPri, int numSeg) {
	int valor1 = correrReferencia (numPri);
	if (valor1 < 0) return valor1;
	int valor2 = correrReferencia (numSeg);
	if (valor2 < 0) return valor2;
	
	int highNible = valor1 << 4;
	highNible =  highNible & 0xf0;
	valor2 = valor2 & 0x0f;
	
	return (highNible | valor2);
}

int decode (int infd, int outfd) {
	int c = 0;
	int caracter2 = 0;
	int caracter = 0;
	ssize_t bytes = read(infd, &caracter, 1);
	if (bytes < 0) bytes = 0 - ERROR_CONST;
	
	while (bytes > 0) {
		bytes = read (infd, &caracter2, 1);
		if (bytes < 0) bytes = 0 - ERROR_CONST;
		else {
			c = byte_decoder(caracter,caracter2);
			if (c < 0) bytes = c; // caracteres no hexa
			else {
				if (write(outfd, &c, 1) < 0) bytes = 1 - ERROR_CONST; // error escritura
				else {
					bytes = read(infd, &caracter, 1);
					if (bytes < 0) bytes = 0 - ERROR_CONST;
				}
			}
		}
	}
	return bytes;
	}
