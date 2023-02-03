#include "textflag.h"



// func x64popcount(a []byte, b []byte,target []byte)
// Requires: AVX, AVX2
TEXT ·x64popcount(SB), NOSPLIT, $0-72
	MOVQ 		a_base+0(FP), R8       	// load address of a
	MOVQ 		a_base+8(FP), R9      	    // length of a
    XORQ 		R15, R15            // Clear R14

	CMPQ 		R9, $0x010        	// Less than 2 quadwords remaining?
	JL   		tail16

body16: // double pumping
	MOVQ 	    (R8), R11           // load qword from a
    MOVQ 	    8(R8), R12          // load next qword from a
    POPCNTQ     R11,R13             // Count bits
    ADDQ        R13,R15             // Accumulate
    POPCNTQ     R12,R14             // count bits
    ADDQ        R14,R15             // Accumulate
    ADDQ        $0x10,R8            // move offset
	SUBQ        $0x10,R9            // subtract from length
    CMPQ        R9,$0x10            // Do we have at least 2 qwords remaining?
    JGE         body16

tail16:
    CMPQ        R9,$0x08           // Do we have at least 8 bytes remaining
    JL          tail8

body8:
    MOVQ        (R8),R11            // load data
    POPCNTQ     R11,R13             // count bits
    ADDQ        R13,R15             // accumulate
    ADDQ        $0x08,R8            // move offset
	SUBQ        $0x08,R9            // subtract from length
    CMPQ        R9,$0x01            // Do we have at least 2 qwords remaining?
    JL          done

tail8:
    XORQ        R11,R11
body1:
	MOVB 		(R8), R11        	// load byte from a
	POPCNTQ     R11,R13        	    // count bits
    ADDQ        R13,R15             // accumulate
	ADDQ        $0x01,R8            // add 1 to offset
	SUBQ        $0x01,R9            // subtract from count
    CMPQ        R9,$0x01            // do we have at least 1 byte remaining?
    JGE         body8

done:
    MOVQ        R15,ret+24(FP)          // Return counts
	RET
