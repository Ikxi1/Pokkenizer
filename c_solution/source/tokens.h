#ifndef TOKENS_H
#define TOKENS_H
#include <stddef.h>

char *strtoktok_r (char *string, const char *delimiters, char **save_ptr, char *token_buffer, size_t *string_position);

#endif //TOKENS_H
