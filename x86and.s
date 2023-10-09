#include "textflag.h"

// func x64and(a []byte, b []byte,target []byte)
// Requires: AVX, AVX2
TEXT ·x64and(SB), NOSPLIT, $0-72
	MOVQ a_base+0(FP), R8   // load address of a
	MOVQ b_base+24(FP), R9  // load address of b
	MOVQ target_base+48(FP), R10 // load address of target
	MOVQ b_len+32(FP), R11  // load length of b as count
	XORQ R12, R12           // Clear R12

	// perform vectorized operation for every block of 512 bits
	CMPQ R11, $0x040 // Less than 8 quadwords remaining?
	JL   tail256

body256:
	VMOVDQA (R9), Y0    // load 4 qwords from b into Y0
	VMOVDQA (R8), Y1
	VPAND   Y0, Y1, Y2
	VMOVDQA Y2, (R10)

	// continue the iteration by moving read pointers
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
	MOVQ (R9), R12  // load qword from a into R12
	ANDQ (R8), R12  // and qword at(a) with R12
	MOVQ R12, (R10) // write qword result to target

	ADDQ $0x08, R8
	ADDQ $0x08, R9
	ADDQ $0x08, R10 // increment 8 bytes
	SUBQ $0x08, R11
	CMPQ R11, $0x08
	JGE  body64

tail64:
	CMPQ R11, $0x00
	JEQ  done

bodyBytes:
	// perform the logical "AND" operation
	MOVB (R9), R12
	ANDB (R8), R12
	MOVB R12, (R10)

	// continue the interation by moving read pointers
	ADDQ $0x01, R8
	ADDQ $0x01, R9
	ADDQ $0x01, R10
	SUBQ $0x01, R11
	JG   bodyBytes

done:
	RET

// func avx512and(a []byte, b []byte,target []byte)
// Requires: AVX-512f
// TEXT ·avx512and(SB), NOSPLIT, $0-72
// 	MOVQ a_base+0(FP), R8   // load address of a
// 	MOVQ b_base+24(FP), R9  // load address of b
// 	MOVQ target_base+48(FP), R10 // load address of target
// 	MOVQ b_len+32(FP), R11  // load length of b as count
// 	XORQ R12, R12           // Clear R12

// 	// perform vectorized operation for every block of 512 bits
// 	CMPQ R11, $0x040 // Less than 8 quadwords remaining?
// 	JL   tail512

// body512:
// 	VMOVUPD (R9), Z1
// 	VMOVUPD (R8), Z2
// //	VMOVUPS (R9), Z1   // load 8 qwords from b into Ymm1
// //	VMOVUPS (R8), Z2
// 	VPANDD  Z2, Z1, Z1 // Z1 = Z2 and Z1
// 	VMOVUPD Z1, (R10)
// //	VMOVUPS Z1, (R10)  // write 8 qwords result to target

// 	// continue the interation by moving read pointers
// 	ADDQ $0x040, R8  // increment 8 qwords
// 	ADDQ $0x040, R9  // increment 8 qwords
// 	ADDQ $0x040, R10 // increment 8 qwords
// 	SUBQ $0x040, R11 // decrement 8 from count
// 	CMPQ R11, $0x040 // Less than 8 quadwords remaining?
// 	JGE  body512

// tail512:
// 	CMPQ R11, $0x020 // Less than 4 quadwords remaining?
// 	JL   tail256

// 	VMOVUPD (R9), Y0   // load 4 qwords from b into Y0
// 	VMOVUPD (R8), Y2   // load 4 qwords from a into Y2
// 	VPAND   Y2, Y0, Y0 // Y0 = Y2 and Y0
// 	VMOVUPD Y0, (R10)  // write 4 qwords result to target

// 	ADDQ $0x020, R8  // increment 4 qwords
// 	ADDQ $0x020, R9  // increment 4 qwords
// 	ADDQ $0x020, R10 // increment 4 qwords
// 	SUBQ $0x020, R11 // decrement 4 from count

// tail256:
// 	CMPQ R11, $0x08 // Is there at least a qword
// 	JL   tail64

// body64:
// 	MOVQ (R9), R12  // load qword from a into R12
// 	ANDQ (R8), R12  // and qword at(a) with R12
// 	MOVQ R12, (R10) // write qword result to target

// 	ADDQ $0x08, R8
// 	ADDQ $0x08, R9
// 	ADDQ $0x08, R10 // increment 8 bytes
// 	SUBQ $0x08, R11
// 	CMPQ R11, $0x08
// 	JGE  body64

// tail64:
// 	CMPQ R11, $0x00
// 	JEQ  done

// bodyBytes:
// 	// perform the logical "AND" operation
// 	MOVB (R9), R12
// 	ANDB (R8), R12
// 	MOVB R12, (R10)

// 	// continue the interation by moving read pointers
// 	ADDQ $0x01, R8
// 	ADDQ $0x01, R9
// 	ADDQ $0x01, R10
// 	SUBQ $0x01, R11
// 	JG   bodyBytes

// done:
// 	RET
