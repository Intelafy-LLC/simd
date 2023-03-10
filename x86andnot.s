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
	JL   tail512

body512:
	VMOVDQU (R9), Y0    // load 4 qwords from b into Y0
	VMOVDQU 32(R9), Y1  // load next 4 qwords from b into Y1
	VMOVDQU (R8), Y2
	VMOVDQU 32(R8), Y3
	VPANDN  Y2, Y0, Y0  // and 4 qwords at (a) with Y0 into Y0
	VPANDN  Y3, Y1, Y1  // and next 4 qwords (a) with Y1 into Y1
	VMOVDQU Y0, (R10)   // write 4 qwords result to target
	VMOVDQU Y1, 32(R10) // write next 4 qwords result to target

	// continue the interation by moving read pointers
	ADDQ $0x040, R8  // increment 8 qwords
	ADDQ $0x040, R9  // increment 8 qwords
	ADDQ $0x040, R10 // increment 8 qwords
	SUBQ $0x040, R11 // decrement 8 from count
	CMPQ R11, $0x040 // Less than 8 quadwords remaining?
	JGE  body512

tail512:
	CMPQ R11, $0x020 // Less than 4 quadwords remaining?
	JL   tail256

	VMOVUPD (R9), Y0   // load 4 qwords from b into Y0
	VMOVUPD (R8), Y2   // Load 4 qwords from a into Y2
	VPANDN  Y2, Y0, Y0 // Y0 = Y2 ANDN Y0
	VMOVUPD Y0, (R10)  // write 4 qwords result to target

	ADDQ $0x020, R8  // increment 4 qwords
	ADDQ $0x020, R9  // increment 4 qwords
	ADDQ $0x020, R10 // increment 8 qwords
	SUBQ $0x020, R11 // decrement 4 from count

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

// func avx512andnot(a []byte, b []byte,target []byte)
// Requires: AVX-512f
TEXT ·avx512andnot(SB), NOSPLIT, $0-72
	MOVQ a_base+0(FP), R8   // load address of a
	MOVQ b_base+24(FP), R9  // load address of b
	MOVQ target_base+48(FP), R10 // load address of target
	MOVQ b_len+32(FP), R11  // load length of b as count
	XORQ R12, R12           // Clear R12

	// perform vectorized operation for every block of 512 bits
	CMPQ R11, $0x040 // Less than 8 quadwords remaining?
	JL   tail512

body512:
	VMOVUPS (R9), Z1   // load 8 qwords from b into Z1
	VMOVUPS (R8), Z2   // load 8 qwords from a into Z2
	VPANDND Z2, Z1, Z1 // Z1 = Z2 and Z1
	VMOVUPS Z1, (R10)  // write 8 qwords result to target

	// continue the interation by moving read pointers
	ADDQ $0x040, R8  // increment 8 qwords
	ADDQ $0x040, R9  // increment 8 qwords
	ADDQ $0x040, R10 // increment 8 qwords
	SUBQ $0x040, R11 // decrement 8 from count
	CMPQ R11, $0x040 // Less than 8 quadwords remaining?
	JGE  body512

tail512:
	CMPQ R11, $0x00000020 // Less than 4 quadwords remaining?
	JL   tail256

	VMOVUPD (R9), Y0   // load 4 qwords from b into Y0
	VMOVUPD (R8), Y2
	VPANDN  Y2, Y0, Y0 // and 4 qwords at (a) with Y0 into Y0
	VMOVUPD Y0, (R10)  // write 4 qwords result over a

	ADDQ $0x020, R8  // increment 4 qwords
	ADDQ $0x020, R9  // increment 4 qwords
	ADDQ $0x020, R10 // increment 8 qwords
	SUBQ $0x020, R11 // decrement 4 from count

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

bodyBytes:
	// perform the logical "ANDN" operation
	MOVB  (R9), R12
	MOVB  (R8), R13
	ANDNQ R12, R13, R12
	MOVB  R12, (R10)

	// continue the interation by moving read pointers
	ADDQ $0x01, R8
	ADDQ $0x01, R9
	ADDQ $0x01, R10
	SUBQ $0x01, R11
	JG   bodyBytes

done:
	RET
