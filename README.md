# Pokkenizer

This thing tokenizes any ASCII text on Linux.

### How to use:

`./pokkenizer input_file $'delimiters' $'persistent delimiters'`

`$''` ensures that each character gets send as a byte to the program and not as a string.
If any escape characters are your delimiters like newline, horizontal tab, or just backslash, ' or ", then write it like this:
`'\n\t\\\'\"'`
These strings are literal -> any space will be interpreted as 0x20.

Example:
`./pokkenizer main.asm $' \n\t' $',;.:+-*/\\\'\"()[]{}|&%#='`

This was only tested on ZSH, if it doesn't work in your Shell, please look up how to do it.

### Current features:

- Tokenize a string with any delimiters
- Persistent delimiters (delimiters that should also be tokenized)
- Save tokens in memory

### Planned features:

- Being able to use it inside another program, like a header file or sth

#### In the near future:
- Outputting tokens as file (what format? json?)

#### In the far future:
- SIMD and multi-threading features
- GLIBC independant
- Platform independant


## License

	No warranty.
	Give credit (link this github repo for example).
	Ask for commercial use.
	Don't use it for evil.
