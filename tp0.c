#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <string.h>


char* input_file = NULL;
char* output_file = NULL;

# define BASE 16

char* vecHexa [] = {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"};


 static struct option long_options[] = {
	 {"version", no_argument, 0, 'v'},
     {"help", no_argument, 0, 'h'},
     {"input", required_argument, 0, 'i'},
     {"output", required_argument, 0, 'o'},
     {"action", required_argument, 0, 'a'},
     {0, 0, 0, 0}
};


char* encoder( int numInt){
	
	int highNible = numInt & 0xf0;
	int lowNible = numInt & 0x0f;
	int primerNum = highNible >> 4;
	int segundoNum = lowNible;
	
	char* primerChar = vecHexa[primerNum];
	char* segundoChar = vecHexa[segundoNum];
	
	char* valorHexa = malloc (2*sizeof(char));
	strcpy(valorHexa,primerChar);
	strcat(valorHexa,segundoChar);
	return valorHexa;
}


void encodingEntrada(char* optarg){
	int largo = strlen(optarg);
	int i;
	for( i=0 ; i < largo ; i++){
		int ascii = optarg[i];
		char* s = encoder(ascii);
		printf("%s",s);
		free(s);
	}
	
}

void comprobarAction(char* optarg){
	const char* encode = "encode";
	const char* decode = "decode";
	if( strcmp (optarg ,encode) != 0 && strcmp(optarg,decode) != 0 ){
		encodingEntrada(optarg);	
	}
	
}


void manejar_opciones( int argc , char** argv ){
	
	int option_index = 0;
	int option = getopt_long ( argc, argv, "vhi:o:a: ", long_options, &option_index);
  
    while ( option != -1 ){
		
		switch ( option ){
			case 'v': 
						printf("66.20-Organizacion de Computadoras TP Version 0.0\n");
						break;
			case 'h':
						printf(" -v, --version, Shows the version of TP. \n");
						printf(" -h, --help , Show help \n");
						printf(" -i, --input, Location of the input file\n");
						printf(" -o, --output, Location of the output file\n");
						printf(" -a, --action, Program action: encode (default) or decode \n");
						break;
			case 'i':	
						input_file = optarg;
						printf ("input file: %s\n", input_file);
						break;
			case 'o':
						output_file = optarg;
						printf("output file: %s\n",output_file);
						break;
			case 'a':	
						printf("Action: %s\n",optarg);
						comprobarAction(optarg);
						break;
			default:
							
						break;
		}   
		option = getopt_long ( argc, argv, "vhi:o:a:", long_options, &option_index);      
     
    }	
	
}




int main (int argc, char** argv){
	
	manejar_opciones( argc , argv);
	printf("\n");
	return 0;

}


