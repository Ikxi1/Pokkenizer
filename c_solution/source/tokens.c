#include "tokens.h"

#include <string.h>

char *strtoktok_r (char *string, const char *delimiters, char **save_ptr, char *token_buffer, size_t *string_position) {
	if (string == NULL) string = *save_ptr;

	if (*string == '\0')	{
		// *save_ptr = string;
		return NULL;
	}

	char *end;

	/* Scan leading delimiters.  */
	size_t leading = strspn (string, delimiters);
	while (leading != 0) {
		token_buffer[(*string_position)++] = string[0];
		token_buffer[(*string_position)++] = '\0';
		++string;
		leading = strspn (string, delimiters);
	}

	if (*string == '\0') {
		// *save_ptr = string;
		return NULL;
	}

	/* Find the end of the token.  */
	size_t after = strcspn(string, delimiters);
	memcpy(token_buffer + *string_position, string, after);
	string += after;
	*string_position += after;
	token_buffer[(*string_position)++] = '\0';
	if (*string == '\0') return NULL;
	leading = strspn(string, delimiters);
	while (leading != 0) {
		token_buffer[(*string_position)++] = string[0];
		token_buffer[(*string_position)++] = '\0';
		++string;
		leading = strspn(string, delimiters);
	}
	end = string;
	if (*end == '\0')	{
		// *save_ptr = end;
		return NULL;
	}

	/* Terminate the token and make *SAVE_PTR point past it.  */
	// *end = '\0';
	*save_ptr = end;
	return string;
}
