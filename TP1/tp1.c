#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <string.h>
#include <stdbool.h>
#include <unistd.h>


static char vecHexa [] = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
static const char* b16_errmsg[] = {"Error al leer el archivo de entrada\n",
								   "Error al escribir el archivo de salida\n",
								   "Contiene caracteres que no pertenecen al codigo Hexa\n"};
#define ERROR_CONST 500


// ****************************** ENCODE *******************************
void byte_encoder (char* valorHexa, unsigned int numInt) {
	int highNible = numInt & 0xf0;
	int lowNible = numInt & 0x0f;
	int primerNum = highNible >> 4;
	int segundoNum = lowNible;
	
	valorHexa[0] = vecHexa[primerNum];
	valorHexa[1] = vecHexa[segundoNum];
}

int leer (int finput) {
	int caracter = 0;
	ssize_t bytes = read(finput, &caracter, 1);
	if (bytes < 0) return 0 - ERROR_CONST; // error lectura
	return caracter;
}

int encode (int infd, int outfd) {
	int caracter = leer(infd);
	
	while (caracter > 0) {
		char string[2];
		byte_encoder (string, caracter);
		if (write(outfd, string, 2) < 0) caracter = 1 - ERROR_CONST; // error escritura
		else caracter = leer(infd);
	}
	return caracter;
}

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
	int c;
	int caracter2;
	int caracter = leer(infd);
	
	while (caracter > 0) {
		caracter2 = leer(infd);
		if (caracter2 < 0) caracter = caracter2;
		else {
			c = byte_decoder(caracter,caracter2);
			if (c < 0) caracter = c; // caracteres no hexa
			else {
				if (write(outfd, &c, 1) < 0) caracter = 1 - ERROR_CONST; // error escritura
				else caracter = leer(infd);
			}
		}
	}
	return caracter;
}


// ************************** ESTO QUEDA EN C **************************

static bool encoderActivo = true;

static struct option long_options[] = {
	 {"version", no_argument, 0, 'v'},
     {"help", no_argument, 0, 'h'},
     {"input", required_argument, 0, 'i'},
     {"output", required_argument, 0, 'o'},
     {"action", required_argument, 0, 'a'},
     {0, 0, 0, 0}
};

int procesarArchivos (FILE* finput, FILE* foutput) {
	int infd = fileno (finput);
	int outfd = fileno (foutput);
	int resultado = 0;
	if (encoderActivo) resultado = encode (infd, outfd);
	else resultado = decode (infd, outfd);
	
	if (finput != stdin) fclose(finput);
	if (foutput != stdout) fclose(foutput);
	return resultado;
}

void escribir_error (int errorcode) {
	fprintf(stderr, b16_errmsg[errorcode + ERROR_CONST]);
}

void comprobarAction (char* optarg) {
	if ( strcmp (optarg, "encode") == 0 ) {
		encoderActivo = true;
	}
	if ( strcmp (optarg, "decode") == 0 ) {
		encoderActivo = false;
	}
}

void imprimirAyuda () {
	printf("Usage:\n");
	printf("\t ./tp0 -h\n");
	printf("\t ./tp0 -v\n");
	printf("Options:\n");
	printf("\t -v, --version, Shows the version of TP. \n");
	printf("\t -h, --help , Show help \n");
	printf("\t -i, --input, Location of the input file\n");
	printf("\t -o, --output, Location of the output file\n");
	printf("\t -a, --action, Program action: encode (default) or decode \n");
	printf("Example: \n");
	printf("\t ./tp0 -a encode -i /input -o /output -h\n");
	printf("\t ./tp0 -a decode\n");
}

int opciones (int argc , char** argv, FILE** finput, FILE** foutput) {
	
	int option_index = 0;
	int option = getopt_long ( argc, argv, "vhi:o:a:", long_options, &option_index);
	while ( option != -1 ) {
		
		switch (option) {
			case 'v':
					printf("66.20-Organizacion de Computadoras TP Version 0.0\n");
					return 1;
					break;
			case 'h':
					imprimirAyuda();
					return 1;
					break;
			case 'i':
					(*finput) = fopen(optarg,"r");
					if ((*finput) == NULL) {
						fprintf(stderr,"Error al abrir el archivo input %s\n",optarg);
						exit(1);
				}
				break;
			case 'o':
					(*foutput) = fopen(optarg, "w");
					if ((*foutput) == NULL) {
						fprintf(stderr,"Error al abrir el archivo output %s \n",optarg);
						exit(1);
					}
						break;
			case 'a':
					comprobarAction(optarg);
					break;
			default:
					break;
		}
		
		option = getopt_long ( argc, argv, "vhi:o:a:", long_options, &option_index);
    }
    
	return 0;
}

int main (int argc, char** argv) {
	FILE* finput = stdin;
	FILE* foutput = stdout;
	int opcion = opciones (argc, argv, &finput, &foutput);
	
	if (opcion == 0) {
		int resultado = procesarArchivos (finput, foutput);
		if (resultado < 0) escribir_error(resultado);
	}
	return 0;
}
