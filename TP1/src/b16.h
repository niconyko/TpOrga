#ifndef _b16_H_
#define _b16_H_

extern const char* b16_errmsg[];

extern int encode(int infd, int outfd);
extern int decode(int infd, int outfd);

#endif //_b16_H
