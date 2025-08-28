#include <string.h>
#include <stdio.h>
#include <stdlib.h>

void main () {
	const char *string = "#include";
	void *ptr = memchr(string, 'l', 9);
	// void *buf = calloc(1, 9);
	// memccpy(buf, string, 'e', 9);
	// free(buf);
}
