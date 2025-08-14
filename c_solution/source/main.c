#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, const char * argv[]) {
	FILE *fptr = fopen(argv[1], "r");
	if (fptr == NULL) return 1;
	fseek(fptr, 0, SEEK_END);
	long size = ftell(fptr);
	fseek(fptr, 0, SEEK_SET);
	char *file_buffer = malloc(size + 1);
	char *token_buffer = malloc(size + 1);
	fread(file_buffer, size, 1, fptr);
	fclose(fptr);

	for (int i = 0; i < size; i++) {
		printf("%c", file_buffer[i]);
		if (isalpha(file_buffer[i])) token_buffer[i] = toupper(file_buffer[i]);
		else if (file_buffer[i] == '_') token_buffer[i] = '_';
		else if (isspace(file_buffer[i])) token_buffer[i] = ' ';
	}

	// while (file_buffer != NULL) {
	// 	strtok_r(file_buffer, );
	// }

	free(token_buffer);
	free(file_buffer);
	return 0;
}
