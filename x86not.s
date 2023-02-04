#include "textflag.h"

// func x64not(a []byte, target []byte)
// Requires: AVX, AVX2
TEXT ·x64not(SB), NOSPLIT, $0-48
	MOVQ     a_base+0(FP), R8   // load address of a
	MOVQ     a_len+8(FP), R11  // load length of a
	MOVQ     target_base+24(FP), R10 // load address of target
	XORQ     R13, R13           // Clear R13
	VPCMPEQD Y2, Y2, Y2         // Set all bits to 1

	// perform vectorized operation for every R13ock of 512 bits
	CMPQ R11, $0x040 // Less than 8 quadwords remaining?
	JL   tail512

body512:
	VMOVDQU (R8), Y0    // load 4 qwords from a into Y0
	VMOVDQU 32(R8), Y1  // load next 4 qwords from a into Y1
	VPXOR   Y2, Y0, Y0
	VPXOR   Y2, Y1, Y1
	VMOVDQU Y0, (R10)   // write 4 qwords result over a
	VMOVDQU Y1, 32(R10) // write next 4 qwords result over next a

	// continue the interation by moving read pointers
	ADDQ $0x040, R8  // increment 8 qwords
	ADDQ $0x040, R10 // increment 8 qwords
	SUBQ $0x040, R11 // decrement 8 from count
	CMPQ R11, $0x040 // Less than 8 quadwords remaining?
	JGE  body512

tail512:
	CMPQ R11, $0x00000020 // Less than 4 quadwords remaining?
	JL   tail256

	VMOVUPD (R8), Y0   // load 4 qwords from b into Y0
	VPXOR   Y2, Y0, Y0 // or 4 qwords at (a) with Y0 into Y0
	VMOVUPD Y0, (R10)  // write 4 qwords result over a

	ADDQ $0x020, R8  // increment 4 qwords
	ADDQ $0x020, R10 // increment 8 qwords
	SUBQ $0x020, R11 // decrement 4 from count

tail256:
	CMPQ R11, $0x08 // Is there at least a qword
	JL   tail64

body64:
	MOVQ (R8), R13  // load qword from a into R13
	XORQ $-1, R13   // or qword at(a) with R13
	MOVQ R13, (R10) // write qword result at(a)

	ADDQ $0x08, R8
	ADDQ $0x08, R10 // increment 8 bytes
	SUBQ $0x08, R11
	CMPQ R11, $0x08
	JGE  body64

tail64:
	CMPQ R11, $0x00
	JEQ  done

bodyBytes:
	// perform the logical "OR" operation
	MOVB (R8), R13
	XORB $-1, R13
	MOVB R13, (R10)

	// continue the interation by moving read pointers
	ADDQ $0x01, R8
	ADDQ $0x01, R10
	SUBQ $0x01, R11
	JG   bodyBytes

done:
	RET

// func avx512not(a []byte, target []byte)
// Requires: AVX-512f
TEXT ·avx512not(SB), NOSPLIT, $0-48
	MOVQ     a_base+0(FP), R8   // load address of a
	MOVQ     a_len+8(FP), R11  // load length of a
	MOVQ     target_base+24(FP), R10 // load address of target
	XORQ     R13, R13           // Clear R13
	VPCMPEQD Y2, Y2, Y2         // Set all bits to 1

	// perform vectorized operation for every R13ock of 512 bits
	CMPQ R11, $0x040 // Less than 8 quadwords remaining?
	JL   tail512

body512:
	VMOVUPS (R8), Z1   // load 8 qwords from a into Ymm1
	VPXORD  Z2, Z1, Z1 // z1 = z2 (all 1's) xor z1
	VMOVUPS Z1, (R10)  // write 8 qwords result to target

	// continue the interation by moving read pointers
	ADDQ $0x040, R8  // increment 8 qwords
	ADDQ $0x040, R10 // increment 8 qwords
	SUBQ $0x040, R11 // decrement 8 from count
	CMPQ R11, $0x040 // Less than 8 quadwords remaining?
	JGE  body512

tail512:
	CMPQ R11, $0x00000020 // Less than 4 quadwords remaining?
	JL   tail256

	VMOVUPD (R8), Y0   // load 4 qwords from b into Y0
	VPXOR   Y2, Y0, Y0 // Xor Y0 with Y2 (all 1's)
	VMOVUPD Y0, (R10)  // write 4 qwords result to target

	ADDQ $0x020, R8  // increment 4 qwords
	ADDQ $0x020, R10 // increment 8 qwords
	SUBQ $0x020, R11 // decrement 4 from count

tail256:
	CMPQ R11, $0x08 // Is there at least a qword
	JL   tail64

body64:
	MOVQ (R8), R13  // load qword from a into R13
	XORQ $-1, R13   // xor qword at(a) all 1's
	MOVQ R13, (R10) // write qword result to target

	ADDQ $0x08, R8
	ADDQ $0x08, R10 // increment 8 bytes
	SUBQ $0x08, R11
	CMPQ R11, $0x08
	JGE  body64

tail64:
	CMPQ R11, $0x00
	JEQ  done

bodyBytes:
	// perform the logical "OR" operation
	MOVB (R8), R13
	XORB $-1, R13
	MOVB R13, (R10)

	// continue the interation by moving read pointers
	ADDQ $0x01, R8
	ADDQ $0x01, R10
	SUBQ $0x01, R11
	JG   bodyBytes

done:
	RET

