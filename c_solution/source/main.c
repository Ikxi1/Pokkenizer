#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "tokens.h"

// Get the sub-tokens of a token
void get_token_tokens (char *token, const char *persistent_delimiters, char *token_buffer, int *string_position) {
	char *save_ptr;
	char *token2 = strtok_r(token, persistent_delimiters, &save_ptr);
	if (token2 == NULL || token2 == "\0") return;
	int token_length = (int)strlen(token2) + 1;
	memcpy(token_buffer + *string_position, token2, token_length);
	*string_position += token_length;

	while (1) {
		token2 = strtok_r(NULL, persistent_delimiters, &save_ptr);
		if (token2 == NULL || token2 == "\0") return;

		token_length = (int)strlen(token2) + 1;
		memcpy(token_buffer + *string_position, token2, token_length);
		*string_position += token_length;
	}
}

// Get the tokens
void get_tokens (char *file_buffer, const char *delimiters, const char *persistent_delimiters, char *token_buffer) {
	char *save_prt;
	int string_position = 0;
	char *token = strtok_r(file_buffer, delimiters, &save_prt);

	get_token_tokens(token, persistent_delimiters, token_buffer, &string_position);

	while (1) {
		token = strtok_r(NULL, delimiters, &save_prt);
		if (token == NULL || token == "\0") return;
		get_token_tokens(token, persistent_delimiters, token_buffer, &string_position);
	}
}

int main (const int argc, const char *argv[]) {
	const char *delimiters;
	const char *persistent_delimiters;
	if (argc < 3) {
		printf("No delimiters were provided, running with default delimiters.");
		delimiters = " \t\n";
		persistent_delimiters = "+-*/\\,;()[]{}=\"\'#<>&|%";
	} else {
		delimiters = argv[2];
		persistent_delimiters = argv[3];
	}
	FILE *fptr = fopen(argv[1], "r");
	if (fptr == NULL) return 2;
	fseek(fptr, 0, SEEK_END);
	const int size = (int)ftell(fptr);
	if (size == 0) return 3;
	fseek(fptr, 0, SEEK_SET);
	char *file_buffer = malloc(size + 1);
	fread(file_buffer, size, 1, fptr);
	fclose(fptr);

	char *token_buffer = calloc(1, size*2 + 1);

	get_tokens(file_buffer, delimiters, persistent_delimiters, token_buffer);
	write(STDOUT_FILENO, token_buffer, size*2 + 1);

	free(token_buffer);
	free(file_buffer);
	return 0;
}
