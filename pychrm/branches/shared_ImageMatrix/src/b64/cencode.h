/*
cencode.h - c header for a base64 encoding algorithm

This is part of the libb64 project, and has been placed in the public domain.
For details, see http://sourceforge.net/projects/libb64
*/

#ifndef BASE64_CENCODE_H
#define BASE64_CENCODE_H

#include <stdlib.h> // for size_t


typedef enum
{
	step_A, step_B, step_C
} base64_encodestep;

typedef struct
{
	base64_encodestep step;
	char result;
	int stepcount;
	int chars_per_line; // 0 for no newlines
	char use_padding; // 0 for no padding
} base64_encodestate;

void base64_init_encodestate(base64_encodestate* state_in, char newlines, char padding);

char base64_encode_value(char value_in);

size_t base64_encode_block(const char* plaintext_in, size_t length_in, char* code_out, base64_encodestate* state_in);

size_t base64_encode_blockend(char* code_out, base64_encodestate* state_in);

#endif /* BASE64_CENCODE_H */
