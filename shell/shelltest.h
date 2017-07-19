#ifndef		SHELLTEST_H
#define	SHELLTEST_H

#define	INTR	2
#define	QUIT	3
#define LINSIZ 1000
#define ARGSIZ 50
#define TRESIZ 100

#define QUOTE 0200
#define FAND 1
#define FCAT 2
#define FPIN 4
#define FPOU 8
#define FPAR 16
#define FINT 32
#define FPRS 64
#define TCOM 1
#define TPAR 2
#define TFIL 3
#define TLST 4
#define DTYP 0
#define DLEF 1
#define DRIT 2
#define DFLG 3
#define DSPR 4
#define DCOM 5
#define	ENOMEM	12
#define	ENOEXEC 8

void main1();
void word();
int tree(int n);
int getc();
char readc();
int syntax(char **p1, char **p2);
int syn1(char **p1, char **p2);
int syn2(char **p1, char **p2);
int syn3(char **p1, char **p2);
void scan(int *at, int(*f)());
int tglob(int c);
int trim(int c);
int execute(int *t, int *pf1, int *pf2);
void texec(int f, int *at);
void err(char s);
void prs(char *as)
void putch(char c);
void prnum(int n);
int any(int c, char *as);
int equal(char *as1, *as2);
void pwait(int i, int *t);
void acct(int *t);
void enacct(char *as);

#endif
