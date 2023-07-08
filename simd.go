package simd

import (
	"log"

	"github.com/klauspost/cpuid/v2"
)

//go:noescape
func x64and(a []byte, b []byte, target []byte)
func avx512and(a []byte, b []byte, target []byte)
func x64andnot(a []byte, b []byte, target []byte)
func avx512andnot(a []byte, b []byte, target []byte)
func x64or(a []byte, b []byte, target []byte)
func avx512or(a []byte, b []byte, target []byte)
func x64not(a []byte, target []byte)
func avx512not(a []byte, target []byte)
func x64ones(a []byte)
func x64zero(a []byte)
func x64popcount(a []byte) int64

func x64intersection(a, b []byte) int64
func x64intersectioncounts(a, b []byte) (icount, acount, bcount int64)
func x64has(a []byte, index int) bool

var (
	AvxAnd                func([]byte, []byte, []byte)
	AvxAndNot             func([]byte, []byte, []byte)
	AvxOr                 func([]byte, []byte, []byte)
	AvxNot                func([]byte, []byte)
	AvxOnes               func([]byte)
	AvxZero               func([]byte)
	AvxPopCount           func([]byte) int64
	AvxIntersection       func([]byte, []byte) int64
	AvxIntersectionCounts func([]byte, []byte) (intersect, acount, bcount int64)
	X64Has                func([]byte, int) bool
)

func init() {
	// cpuid.Flags()
	// flag.Parse()
	AvxPopCount = x64popcount // doesn't really use avx
	AvxIntersection = x64intersection
	AvxIntersectionCounts = x64intersectioncounts
	X64Has = x64has
	cpuid.Detect()
	if cpuid.CPU.Supports(cpuid.AVX512F) {
		log.Println("avx512 supported")
		AvxAnd = avx512and
		AvxAndNot = avx512andnot
		AvxOr = avx512or
		AvxNot = avx512not
		AvxOnes = x64ones
		AvxZero = x64zero
		return
	}
	AvxAnd = x64and
	AvxAndNot = x64andnot
	AvxOr = x64or
	AvxNot = x64not
	AvxOnes = x64ones
	AvxZero = x64zero

}
