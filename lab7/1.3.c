#include <stdio.h>

extern char** environ;

int main(int argc, char *argv[])
{
	char** ptr = environ;
	for (;*ptr && ptr - environ < 10; ptr++)
		printf("[%d] %s\n", ptr - environ, *ptr);

	return 0;
}