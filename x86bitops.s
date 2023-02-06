#include "textflag.h"
// func x64has(a []byte,index int) bool
TEXT ·x64has(SB), NOSPLIT, $0-33
	MOVQ     a_base+0(FP), R8         // load address of a
	MOVQ     a_len+8(FP), R9          // load length of a
	MOVQ     index+24(FP), R11 			// load index

	MOVB     R11,CL
	SHRQ     $3,R11
	CMPQ     R11,R9
	JGE      false
	ADDQ     R11,R8
	MOVB     (R8),BL
	ANDB    $7,CL
	MOVB    $1,DL
	SHLB     CL,DL
	ANDB     BL,DL
	JZ       false

	MOVB     $1,ret+32(FP)
	RET

false:
	MOVB     $0,ret+32(FP)
	RET
	




// func x64ones(a []byte)
// Requires: AVX, AVX2
TEXT ·x64ones(SB), NOSPLIT, $0-24
	MOVQ     a_base+0(FP), R8         // load address of a
	MOVQ     a_len+8(FP), R11        // load length of a
	MOVQ     $0xffffffffffffffff, R13 // set R13 to all 1's
	VPCMPEQQ Y1, Y1, Y2               // Set all bits to 1

	// perform vectorized operation for every R13ock of 512 bits
	CMPQ R11, $0x040 // Less than 8 quadwords remaining?
	JL   tail512

body512:
	VMOVDQU Y2, (R8)   // write 4 qwords result over a
	VMOVDQU Y2, 32(R8) // write 4 qwords result over a

	// continue the interation by moving read pointers
	ADDQ $0x040, R8  // increment 8 qwords
	SUBQ $0x040, R11 // decrement 8 from count
	CMPQ R11, $0x040 // Less than 8 quadwords remaining?
	JGE  body512

tail512:
	CMPQ R11, $0x00000020 // Less than 4 quadwords remaining?
	JL   tail256

	VMOVUPD Y2, (R8) // write 4 qwords result over a

	ADDQ $0x020, R8  // increment 4 qwords
	SUBQ $0x020, R11 // decrement 4 from count

tail256:
	CMPQ R11, $0x08 // Is there at least a qword
	JL   tail64

body64:
	MOVQ R13, (R8) // write qword result at(a)

	ADDQ $0x08, R8
	SUBQ $0x08, R11
	CMPQ R11, $0x08
	JGE  body64

tail64:
	CMPQ R11, $0x00
	JEQ  done

bodyBytes:
	MOVB R13, (R8)

	// continue the interation by moving read pointers
	ADDQ $0x01, R8
	SUBQ $0x01, R11
	JG   bodyBytes

done:
	RET

// func x64zero(a []byte)
// Requires: AVX, AVX2
TEXT ·x64zero(SB), NOSPLIT, $0-24
	MOVQ  a_base+0(FP), R8  // load address of a
	MOVQ  a_len+8(FP), R11 // load length of a
	MOVQ  $0x0, R13         // set R13 to all 1's
	VPXOR Y2, Y2, Y2        // clear Y2

	// perform vectorized operation for every R13ock of 512 bits
	CMPQ R11, $0x040 // Less than 8 quadwords remaining?
	JL   tail512

body512:
	VMOVDQU Y2, (R8)   // write 4 qwords result over a
	VMOVDQU Y2, 32(R8) // write 4 qwords result over a

	// continue the interation by moving read pointers
	ADDQ $0x040, R8  // increment 8 qwords
	SUBQ $0x040, R11 // decrement 8 from count
	CMPQ R11, $0x040 // Less than 8 quadwords remaining?
	JGE  body512

tail512:
	CMPQ R11, $0x00000020 // Less than 4 quadwords remaining?
	JL   tail256

	VMOVUPD Y2, (R8) // write 4 qwords result over a

	ADDQ $0x020, R8  // increment 4 qwords
	SUBQ $0x020, R11 // decrement 4 from count

tail256:
	CMPQ R11, $0x08 // Is there at least a qword
	JL   tail64

body64:
	MOVQ R13, (R8) // write qword result at(a)

	ADDQ $0x08, R8
	SUBQ $0x08, R11
	CMPQ R11, $0x08
	JGE  body64

tail64:
	CMPQ R11, $0x00
	JEQ  done

bodyBytes:
	MOVB R13, (R8)

	// continue the interation by moving read pointers
	ADDQ $0x01, R8
	SUBQ $0x01, R11
	JG   bodyBytes

done:
	RET
