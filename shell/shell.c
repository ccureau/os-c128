#include <conio.h>
#include <string.h>
#include "shell.h"
#include "util.h"

char  *prompt;
char  peekc;
char  **argp;
char  **eargp;
int	  *treep;
int	  *treeend;
char  error;

char	line[LINESIZE];
char	*args[ARGSIZE];
int	  treebuf[TREESIZE];

int main(int argc, char **argv)
{
  // set up variables

  prompt = "$ ";

  // read args and process (eventually...)

  // additional setup
  cursor(1);

  // read a character, call main1, repeat...
  loop:
  if (prompt != 0) {
    cputs(prompt);
  }
  peekc = cgetc();
  main1();
  goto loop;
}

void main1()
{
  char c, *cp, *t;

  argp = args;

}

word()
{
	register char c, c1;

	*argp++ = linep;

loop:
	switch(c = getc()) {

	case ' ':
	case '\t':
		goto loop;

	case '\'':
	case '"':
		c1 = c;
		while((c=readc()) != c1) {
			if(c == '\n') {
				error++;
				peekc = c;
				return;
			}
			*linep++ = c|QUOTE;
		}
		goto pack;

	case '&':
	case ';':
	case '<':
	case '>':
	case '(':
	case ')':
	case '|':
	case '^':
	case '\n':
		*linep++ = c;
		*linep++ = '\0';
		return;
	}

	peekc = c;

pack:
	for(;;) {
		c = getc();
		if(any(c, " '\"\t;&<>()|^\n")) {
			peekc = c;
			if(any(c, "\"'"))
				goto loop;
			*linep++ = '\0';
			return;
		}
		*linep++ = c;
	}
}
