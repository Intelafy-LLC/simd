#include "textflag.h"



TEXT ·x64intersectioncounts(SB), NOSPLIT, $0-56
	MOVQ a_base+0(FP), R8  // load address of a
	MOVQ b_base+24(FP), R9 // load address of b
	MOVQ b_len+32(FP), R11 // load length of b as count
	XORQ R10,R10	// A count
	XORQ R15,R15    // B Count
	XORQ R14, R14   // Intersection Count

	CMPQ R11, $0x010 // Less than 2 quadwords remaining?
	JL   tail16

	// process 16 bytes at a time
body16:

	VMOVDQU (R8), X2
	VMOVDQU (R9), X3      // load 2 qwords from b into X0
	VPAND   X2, X3, X0    // and 2 qwords at (a) with X0 into X1
	MOVQ    X0, R12       // Get low qword
	POPCNTQ R12, R12      // count bits
	ADDQ    R12, R14      // Accumulate
	PSHUFD  $0xEE, X0, X0 // Shift upper 64 bits to lower
	MOVQ    X0, R12       // Extract low qword
	POPCNTQ R12, R12      // Count bits
	ADDQ    R12, R14      // Accumulate
// A & B Counts
	MOVQ    X2, R12       // Get low Qword for A
	MOVQ    X3, R13       // Get low Qword for B
	POPCNTQ R12, R12      // Count A bits
	POPCNTQ R13, R13      // Count B bits
	ADDQ    R12, R10      // Accumulate a count
	ADDQ    R13, R15      // Accumulate b count
	PSHUFD  $0xEE,X2,X2   // Shift upper 64 bits to lower for A
	PSHUFD  $0xEE,X3,X3   // ditto B
	MOVQ    X2, R12       // Get "upper" Qword for A
	MOVQ    X3, R13       // Get "upper" Qword for B
	POPCNTQ R12, R12      // Count A bits
	POPCNTQ R13, R13      // Count B bits
	ADDQ    R12, R10      // Accumulate A bit count
	ADDQ    R13, R15      // accumulate b bit count
	SUBQ    $0x10, R11    // Subtract 16 bytes
	ADDQ    $0x10, R8     // increment 16 bytes
	ADDQ    $0x10, R9     // increment 16 bytes
	CMPQ    R11, $0x10    // Are there at least 16 bytes left?
	JGE     body16

tail16:
	CMPQ R11, $0x8 // Are there at least 8 bytes left?
	JL   tail8

body8:
	MOVQ    (R8), R12     // Load A
	POPCNTQ R12, R13      // Count a bits
	ADDQ    R13, R10      // Accumulate A
	MOVQ    R10, X0       // Save A Accumulator
	MOVQ    (R9), R10     // Load B
	POPCNTQ R10, R13      // Count B
	ADDQ    R13, R15      // Accumulate B
	ANDQ    R12,R10       // A and B
	POPCNTQ R10,R13       // Count intersection
	ADDQ    R13, R14      // Accumulate intersection
	MOVQ    X0, R10       // Restore B accumulator
	SUBQ    $0x08, R11
	ADDQ    $0x08, R8
	ADDQ    $0x08, R9
	CMPQ    R11, $0x08 // Are there at least 64 bytes left?
	JGE     body8

tail8:
	CMPQ R11, $0x01 // Is there at least 1 byte left?
	JL   done


body1:
	XORQ 	R12, R12   // Clear R12
	MOVB    (R8), R12  // Load A
	POPCNTQ R12, R13   // Count A
	ADDQ    R13, R10   // Accumulate A
	MOVQ    R10, X0    // Save A Accumulator
// B
	XORQ    R10, R10
	MOVB    (R9), R10  // Load B
	POPCNTQ R10, R13   // Count B 
	ADDQ    R13, R15   // Accumulate B
	ANDQ    R10, R12   // A & B
	POPCNTQ R12, R13   // Count bits
	ADDQ    R13, R14   // Accumulate Intersection
	MOVQ    X0, R10    // Restore B accumulator
	SUBQ    $0x01, R11
	ADDQ    $0x01, R8
	ADDQ    $0x01, R9
	CMPQ    R11, $0x01 // Are there at least 64 bytes left?
	JGE     body1

done:
	MOVQ R14, ret+48(FP) // intersection counts
	MOVQ R10, ret+56(FP) // a counts
	MOVQ R15, ret+64(FP) // b counts
	RET


//**************************


TEXT ·x64intersectioncountsright(SB), NOSPLIT, $0-56
	MOVQ a_base+0(FP), R8  // load address of a
	MOVQ b_base+24(FP), R9 // load address of b
	MOVQ b_len+32(FP), R11 // load length of b as count
	XORQ R10,R10	// B count
	XORQ R14, R14   // Intersection Count

	CMPQ R11, $0x010 // Less than 2 quadwords remaining?
	JL   tail16

	// process 16 bytes at a time
body16:

	VMOVDQU (R8), X2
	VMOVDQU (R9), X3      // load 2 qwords from b into X0
	VPAND   X2, X3, X0    // and 2 qwords at (a) with X0 into X1
	MOVQ    X0, R12       // Get low qword
	POPCNTQ R12, R12      // count bits
	ADDQ    R12, R14      // Accumulate
	PSHUFD  $0xEE, X0, X0 // Shift upper 64 bits to lower
	MOVQ    X0, R12       // Extract low qword
	POPCNTQ R12, R12      // Count bits
	ADDQ    R12, R14      // Accumulate
// B Count
	MOVQ    X3, R13       // Get low Qword for B
	POPCNTQ R13, R13      // Count B bits
	ADDQ    R13, R10      // Accumulate b count
	PSHUFD  $0xEE,X3,X3   // ditto B
	MOVQ    X3, R13       // Get "upper" Qword for B
	POPCNTQ R13, R13      // Count B bits
	ADDQ    R13, R10      // accumulate b bit count
	SUBQ    $0x10, R11    // Subtract 16 bytes
	ADDQ    $0x10, R8     // increment 16 bytes
	ADDQ    $0x10, R9     // increment 16 bytes
	CMPQ    R11, $0x10    // Are there at least 16 bytes left?
	JGE     body16

tail16:
	CMPQ R11, $0x8 // Are there at least 8 bytes left?
	JL   tail8

body8:
	MOVQ    (R8), R12     // Load A
	MOVQ    (R9), R13     // Load B
	ANDQ    R13, R12      // A & B
	POPCNTQ R13, R13      // Count B
	POPCNTQ R12, R12      // Count intersection
	ADDQ    R13, R10      // Accumulate B
	ADDQ    R12, R14      // Accumulate intersection
	SUBQ    $0x08, R11
	ADDQ    $0x08, R8
	ADDQ    $0x08, R9
	CMPQ    R11, $0x08 // Are there at least 64 bytes left?
	JGE     body8

tail8:
	CMPQ R11, $0x01 // Is there at least 1 byte left?
	JL   done


body1:
	XORQ 	R12, R12   // Clear R12 for A
	MOVB    (R8), R12  // Load A
// B
	XORQ    R13, R13   // Clear for B
	MOVB    (R9), R13  // Load B
	ANDQ    R13, R12   // A & B
	POPCNTQ R13, R13   // Count B 
	POPCNTQ R12, R12
	ADDQ    R13, R10   // Accumulate B
	ADDQ    R12, R14   // Accumulate Intersection
	SUBQ    $0x01, R11
	ADDQ    $0x01, R8
	ADDQ    $0x01, R9
	CMPQ    R11, $0x01 // Are there at least 64 bytes left?
	JGE     body1

done:
	MOVQ R14, ret+48(FP) // intersection counts
	MOVQ R10, ret+56(FP) // b counts
	RET



//---------------------------------------------------------------------------------
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
