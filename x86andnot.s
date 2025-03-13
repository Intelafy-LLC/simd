#include "textflag.h"

// func x64andnot(a []byte, b []byte,target []byte)
// Requires: AVX, AVX2
TEXT ·x64andnot(SB), NOSPLIT, $0-72
	MOVQ a_base+0(FP), R8   // load address of a
	MOVQ b_base+24(FP), R9  // load address of b
	MOVQ target_base+48(FP), R10 // load address of target
	MOVQ b_len+32(FP), R11  // load length of b as count

	// perform vectorized operation for every block of 512 bits
	CMPQ R11, $0x040 // Less than 8 quadwords remaining?
	JL   tail256

body256:
	VMOVDQA (R9), Y0    // load 4 qwords from b into Y0
	VMOVDQA (R8), Y1
	VPANDN  Y1, Y0, Y2
	VMOVDQU Y2, (R10)

	// continue the interation by moving read pointers
	ADDQ $0x020, R8  // increment 8 qwords
	ADDQ $0x020, R9  // increment 8 qwords
	ADDQ $0x020, R10 // increment 8 qwords
	SUBQ $0x020, R11 // decrement 8 from count
	CMPQ R11, $0x020 // Less than 8 quadwords remaining?
	JGE  body256

tail256:
	CMPQ R11, $0x08 // Is there at least a qword
	JL   tail64

body64:
	MOVQ  (R9), R12      // load qword from a into R12
	ANDNQ (R8), R12, R12 // and qword at(a) with R12
	MOVQ  R12, (R10)     // write qword result at(a)

	ADDQ $0x08, R8
	ADDQ $0x08, R9
	ADDQ $0x08, R10 // increment 8 bytes
	SUBQ $0x08, R11
	CMPQ R11, $0x08
	JGE  body64

tail64:
	CMPQ R11, $0x00
	JEQ  done
	XORQ R12, R12   // Clear R12
	XORQ R13, R13   // Clear R13

bodyBytes:
	// perform the logical "ANDN" operation
	MOVB  (R9), R12
	MOVB  (R8), R13
	ANDNQ R13, R12, R12
	MOVB  R12, (R10)

	// continue the interation by moving read pointers
	ADDQ $0x01, R8
	ADDQ $0x01, R9
	ADDQ $0x01, R10
	SUBQ $0x01, R11
	JG   bodyBytes

done:
	RET

