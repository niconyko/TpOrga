#ifndef _b16C_H_
#define _b16C_H_

// ********** IR COMENTANDO A MEDIDA QUE SE VAN IMPLEMENTANDO **********

extern const char* b16_errmsg[];
#define ERROR_CONST 500

//extern int encode(int infd, int outfd);
extern int decode(int infd, int outfd);

#endif //_b16C_H
