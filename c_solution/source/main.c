#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int get_token_amount(char *file_buffer, char *delimiters, int size) {
	char *internal_file_buffer;
	memcpy(internal_file_buffer, file_buffer, size + 1);
	char *save_prt;
	char *token = strtok_r(internal_file_buffer, delimiters, &save_prt);
	int token_count = 1;
	while (1) {
		printf(token);
		token = strtok_r(NULL, delimiters, &save_prt);
		if (token == NULL || token == "\0") break;
		token_count++;
	}
	return token_count;
}

void get_tokens(char *file_buffer, char *delimiters, char *token_buffer) {
	char *save_prt;
	char *token = strtok_r(file_buffer, delimiters, &save_prt);
	int string_position = (int)strlen(token) +1;
	for (int i = 0; i < string_position; i++) {
		token_buffer[i] = token[i];
	}

	while (1) {
		printf(token);
		token = strtok_r(NULL, delimiters, &save_prt);
		if (token == NULL || token == "\0") break;

		int token_length = (int)strlen(token) + 1;
		for (int i = 0; i < token_length; i++) {
			token_buffer[i + string_position] = token[i];
		}
		string_position += token_length;
	}
}

int main(int argc, const char * argv[]) {
	FILE *fptr = fopen(argv[1], "r");
	if (fptr == NULL) return 1;
	fseek(fptr, 0, SEEK_END);
	long size = ftell(fptr);
	fseek(fptr, 0, SEEK_SET);
	char *file_buffer = malloc(size + 1);
	fread(file_buffer, size, 1, fptr);
	fclose(fptr);

	char *delimiters = " \n\t";
	int token_count = get_token_amount(file_buffer, delimiters, size);
	char *token_buffer = malloc(size + 1 + token_count);

	get_tokens(file_buffer, delimiters, token_buffer);

	free(token_buffer);
	free(file_buffer);
	return 0;
}
