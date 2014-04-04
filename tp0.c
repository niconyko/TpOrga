#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <string.h>
#include <stdbool.h>



bool encoderActivo = true;
bool decoderActivo = false;

FILE* finput = NULL;
FILE* foutput = NULL;



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
	char* valorHexa = malloc( sizeof(char)*3 );
	
	strcpy(valorHexa,primerChar);
	strcat(valorHexa,segundoChar);
	
	return valorHexa;
}


int correrReferencia ( int numInt ){
	if( numInt > 47 && numInt < 58)
		return numInt - 48 ;
	
	else if( numInt > 64 && numInt < 71)
		return numInt - 55 ;
	
	else if( numInt > 96 && numInt < 103)
		return numInt - 87 ;
	else {
		fprintf(stderr,"Contiene caracteres que no pertenecen al codigo Hexa\n");
		exit(1);
	}
	
}

char decoder ( int numPri, int numSeg){
	
	int valor1 = correrReferencia( numPri );
	int valor2 = correrReferencia( numSeg );
	
	int highNible = valor1 << 4;
	highNible =  highNible & 0xf0;
	valor2 = valor2 & 0x0f;
	
	char caracter = highNible | valor2;
	
	return caracter;
	

}

void procesarArchivos(FILE* finput, FILE* foutput){
	
	char* string;
	char c;
	int caracter2;
	int caracter = fgetc(finput);
	
	while (caracter != EOF){		
		if(encoderActivo){
			string = encoder(caracter);			
			if(foutput != NULL) fputs(string , foutput);
			else printf("%s",string);
			free(string);
		}
		else{
			
			caracter2 = fgetc(finput);
			c = decoder(caracter,caracter2);
			fputc(c,foutput);
		
		}
		caracter = fgetc(finput);		
	}       
	 
    fclose(finput);
    if(foutput != NULL) fclose(foutput);
}

void EntradaEncoderStandar(){
	
	int c = getchar();
	while( c != EOF){
		char* string = encoder(c);
		printf("%s",string);
		free(string);
		c = getchar();
	}	
}

void EntradaDecoderStandar(){
	int c = getchar();
	int c2 = getchar();
	while( c != EOF){
		char string = decoder(c,c2);
		if( foutput != NULL ) fputc(string,foutput);
		else printf("%c",string);
		c = getchar();
		c2 = getchar();
	}	

}


void comprobarAction(char* optarg){
	if( strcmp ( optarg, "encode" ) == 0 ){
		encoderActivo = true;
		decoderActivo = false;
	}
	if ( strcmp ( optarg, "decode" ) == 0 ){
		encoderActivo = false;
		decoderActivo = true;
	}
	
}


void opciones( int argc , char** argv ){
	
	int option_index = 0;
	int option = getopt_long ( argc, argv, "vhi:o:a: ", long_options, &option_index);
	if( option == -1 ){ 
		EntradaEncoderStandar();
		return;
	}
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
						finput = fopen(optarg,"r");
						if(finput == NULL ){
							fprintf(stderr,"Error al abrir el archivo input %s\n",optarg);
							exit(1);
					}
						break;
			case 'o':
						foutput = fopen(optarg, "w");
						if (foutput == NULL){
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
   
	
}


void controlarOpciones(){
	
	 if (finput != NULL){		
		procesarArchivos(finput,foutput);		
	}
	else{
		if(encoderActivo) EntradaEncoderStandar();
		else EntradaDecoderStandar();
	}

}

int main (int argc, char** argv){
	opciones( argc , argv);
	controlarOpciones();	
	printf("\nSe completo con exito la operacion\n");
	return 0;

}


