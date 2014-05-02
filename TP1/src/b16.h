#ifndef _b16_H_
#define _b16_H_

// ******** IR DESCOMENTANDO A MEDIDA QUE SE VAN IMPLEMENTANDO *********

//extern const char* b16_errmsg[];
#define ERROR_CONST 500
//extern void byte_encoder(char* valorHexam ,unsigned int numInt); 
extern int encode(int infd, int outfd);
//extern int decode(int infd, int outfd);

#endif //_b16_H
