#include "textflag.h"
//***  if thes bytes are not aligned on 256 bit boundary -- will cause seg fault
// func x64or(a []byte, b []byte,target []byte)
// Requires: AVX, AVX2
TEXT ·x64or(SB), NOSPLIT, $0-72
	MOVQ a_base+0(FP), R8   // load address of a
	MOVQ b_base+24(FP), R9  // load address of b
	MOVQ target_base+48(FP), R10 // load address of target
	MOVQ b_len+32(FP), R11  // load length of b as count
	XORQ R13, R13           // Clear R13

	// perform vectorized operation for every block of 512 bits
	CMPQ R11, $0x020 // Less than 4 quadwords remaining?
	JL   tail256

body256:
//	VMOVDQU (R9), Y0    // load 4 qwords from b into Y0
//	VMOVDQU (R8), Y2    // load 4 qwords from a into Y2
	VMOVDQA (R9), Y0    // load 4 qwords from b into Y0
	VMOVDQA (R8), Y2    // load 4 qwords from a into Y2
	VPOR    Y2, Y0, Y0  // y0 = y2 or y0
	VMOVDQA Y0, (R10)   // write 4 qwords result to target
	ADDQ $0x020, R8  // increment 8 qwords
	ADDQ $0x020, R9  // increment 8 qwords
	ADDQ $0x020, R10 // increment 8 qwords
	SUBQ $0x020, R11 // decrement 8 qwords from count
	CMPQ R11, $0x020 // Less than 8 quadwords remaining?
	JGE  body256

tail256:
	CMPQ R11, $0x08 // Is there at least a qword
	JL   tail64

body64:
	MOVQ (R9), R13  // load qword from a into R13
	ORQ  (R8), R13  // or qword at(a) with R13
	MOVQ R13, (R10) // write qword result to target

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
	// perform the logical "OR" operation
	MOVB (R9), BL
	ORB  (R8), BL
	MOVB BL, (R10)

	// continue the interation by moving read pointers
	ADDQ $0x01, R8
	ADDQ $0x01, R9
	ADDQ $0x01, R10
	SUBQ $0x01, R11
	JG   bodyBytes

done:
	RET

// func x64or(a []byte, b []byte,target []byte)
// Requires: AVX-512f
// TEXT ·avx512or(SB), NOSPLIT, $0-72
// 	MOVQ a_base+0(FP), R8   // load address of a
// 	MOVQ b_base+24(FP), R9  // load address of b
// 	MOVQ target_base+48(FP), R10 // load address of target
// 	MOVQ b_len+32(FP), R11  // load length of b as count
// 	XORQ R13, R13           // Clear R13

// 	// perform vectorized operation for every block of 512 bits
// 	CMPQ R11, $0x040 // Less than 8 quadwords?
// 	JL   tail512

// body512:
// 	VMOVDQA64 (R9), Z1
// 	VMOVDQA64 (R8), Z2
// //	VMOVUPD (R9), Z1   // load 8 qwords from b into z1
// //	VMOVUPD (R8), Z2   // load 8 qwords from a into z2
// 	VPORD   Z2, Z1, Z3 // z1 = z2 or z1
// 	VMOVDQA64 Z3,(R10)
// //VMOVUPD Z1, (R10)  // write 8 qwords result to result

// 	// continue the interation by moving read pointers
// 	ADDQ $0x040, R8  // increment 8 qwords
// 	ADDQ $0x040, R9  // increment 8 qwords
// 	ADDQ $0x040, R10 // increment 8 qwords
// 	SUBQ $0x040, R11 // decrement 8 from count
// 	CMPQ R11, $0x040 // Less than 8 quadwords remaining?
// 	JGE  body512

// tail512:
// 	CMPQ R11, $0x00000020 // Less than 4 quadwords remaining?
// 	JL   tail256

// 	VMOVUPD (R9), Y0   // load 4 qwords from b into Y0
// 	VMOVUPD (R8), Y2   // load 4 qwords from a into Y2
// 	VPOR    Y2, Y0, Y0 // y0 = y2 or y0
// 	VMOVUPD Y0, (R10)  // write 4 qwords result to target

// 	ADDQ $0x020, R8  // increment 4 qwords
// 	ADDQ $0x020, R9  // increment 4 qwords
// 	ADDQ $0x020, R10 // increment 4 qwords
// 	SUBQ $0x020, R11 // decrement 4 from count

// tail256:
// 	CMPQ R11, $0x08 // Is there at least a qword
// 	JL   tail64

// body64:
// 	MOVQ (R9), R13  // load qword from a into R13
// 	ORQ  (R8), R13  // or qword at(a) with R13
// 	MOVQ R13, (R10) // write qword result to target

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
// 	// perform the logical "OR" operation
// 	MOVB (R9), BL
// 	ORB  (R8), BL
// 	MOVB BL, (R10)

// 	// continue the interation by moving read pointers
// 	ADDQ $0x01, R8
// 	ADDQ $0x01, R9
// 	ADDQ $0x01, R10
// 	SUBQ $0x01, R11
// 	JG   bodyBytes

// done:
// 	RET
