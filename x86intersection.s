#include "textflag.h"

// func x64intersection(a []byte, b []byte) int64
// Requires: AVX, AVX2
TEXT ·x64intersection(SB), NOSPLIT, $0-56
	MOVQ a_base+0(FP), R8  // load address of a
	MOVQ b_base+24(FP), R9 // load address of b
	MOVQ b_len+32(FP), R11 // load length of b as count
	XORQ R14, R14

	CMPQ R11, $0x010 // Less than 2 quadwords remaining?
	JL   tail16

	// process 16 bytes at a time
body16:
	VMOVDQU (R9), X0      // load 2 qwords from b into X0
	VMOVDQU (R8), X2
	VPAND   X2, X0, X1    // and 2 qwords at (a) with X0 into X1
	MOVQ    X1, R12       // Get low qword
	POPCNTQ R12, R13      // count bits
	ADDQ    R13, R14      // Accumulate
	PSHUFD  $0xEE, X1, X2 // Shift upper 64 bits to lower
	MOVQ    X2, R12       // Extract low qword
	POPCNTQ R12, R13      // Count bits
	ADDQ    R13, R14      // Accumulate
	SUBQ    $0x10, R11    // Subtract 16 bytes
	ADDQ    $0x10, R8     // increment 16 bytes
	ADDQ    $0x10, R9     // increment 16 bytes
	CMPQ    R11, $0x10    // Are there at least 16 bytes left?
	JGE     body16

tail16:
	CMPQ R11, $0x8 // Are there at least 8 bytes left?
	JL   tail8

body8:
	MOVQ    (R8), R12
	ANDQ    (R9), R12
	POPCNTQ R12, R13   // Count bits
	ADDQ    R13, R14   // Accumulate
	SUBQ    $0x08, R11
	ADDQ    $0x08, R8
	ADDQ    $0x08, R9
	CMPQ    R11, $0x08 // Are there at least 64 bytes left?
	JGE     body8

tail8:
	CMPQ R11, $0x01 // Is there at least 1 byte left?
	JL   done
	XORQ R12, R12   // Clear R12

body1:
	MOVB    (R8), R12
	ANDQ    (R9), R12
	POPCNTQ R12, R13   // Count bits
	ADDQ    R13, R14   // Accumulate
	SUBQ    $0x01, R11
	ADDQ    $0x01, R8
	ADDQ    $0x01, R9
	CMPQ    R11, $0x01 // Are there at least 64 bytes left?
	JGE     body1

done:
	MOVQ R14, ret+48(FP) // Return counts
	RET
