#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <string.h>
#include <stdbool.h>

#include "b16.h"
#include "b16c.h" // temporal

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
	int error = errorcode + ERROR_CONST;
	fprintf(stderr, b16_errmsg[error]);
	exit (error);
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
