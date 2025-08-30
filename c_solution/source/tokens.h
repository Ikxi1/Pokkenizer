#ifndef TOKENS_H
#define TOKENS_H
#include <stddef.h>

char *strtoktok_r (char *string, const char *delimiters, char **save_ptr, char *token_buffer);

#endif //TOKENS_H
