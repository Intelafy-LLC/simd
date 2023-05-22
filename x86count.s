#include "textflag.h"

// func x64popcount(a []byte) int64
// Requires: AVX, AVX2
TEXT ·x64popcount(SB), NOSPLIT, $0-32
	MOVQ a_base+0(FP), R8 // load address of a
	MOVQ a_len+8(FP), R9 // length of a
	XORQ R15, R15         // Clear R15

	CMPQ R9, $0x010 // Less than 2 quadwords remaining?
	JL   tail16

body16:  // double pumping
	MOVQ    (R8), R11  // load qword from a
	MOVQ    8(R8), R12 // load next qword from a
	POPCNTQ R11, R13   // Count bits
	ADDQ    R13, R15   // Accumulate
	POPCNTQ R12, R14   // count bits
	ADDQ    R14, R15   // Accumulate
	SUBQ    $0x10, R9  // subtract from length
	ADDQ    $0x10, R8  // move offset
	CMPQ    R9, $0x10  // Do we have at least 2 qwords remaining?
	JGE     body16

tail16:
	CMPQ R9, $0x08 // Do we have at least 8 bytes remaining
	JL   tail8

body8:
	MOVQ    (R8), R11 // load data
	POPCNTQ R11, R13  // count bits
	ADDQ    R13, R15  // accumulate
	SUBQ    $0x08, R9 // subtract from length
	ADDQ    $0x08, R8 // move offset

tail8:
	CMPQ    R9, $0x01 // Do we have at least 1 byte remaining?
	JL      done
	XORQ R11, R11

body1:
	MOVB    (R8), R11 // load byte from a
	POPCNTQ R11, R13  // count bits
	ADDQ    R13, R15  // accumulate
	ADDQ    $0x01, R8 // add 1 to offset
	SUBQ    $0x01, R9 // subtract from count
	JG      body1

done:
	MOVQ R15, ret+24(FP) // Return counts
	RET
