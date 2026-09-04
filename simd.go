package simd

var isAVX512F bool

//go:noescape
func x64and(a []byte, b []byte, target []byte)
func avx512and(a []byte, b []byte, target []byte)
func x64andnot(a []byte, b []byte, target []byte)
func x64or(a []byte, b []byte, target []byte)
func avx512or(a []byte, b []byte, target []byte)
func x64not(a []byte, target []byte)
func x64ones(a []byte)
func x64zero(a []byte)
func x64popcount(a []byte) int64

func x64intersection(a, b []byte) int64
func x64intersectioncounts(a, b []byte) (icount, acount, bcount int64)
func x64intersectioncountsright(a, b []byte) (icount, bcount int64)

func x64has(a []byte, index int) bool

var (
	AvxAnd                     func([]byte, []byte, []byte)
	AvxAndNot                  func([]byte, []byte, []byte)
	AvxOr                      func([]byte, []byte, []byte)
	AvxNot                     func([]byte, []byte)
	AvxOnes                    func([]byte)
	AvxZero                    func([]byte)
	AvxPopCount                func([]byte) int64
	AvxIntersection            func([]byte, []byte) int64
	AvxIntersectionCounts      func([]byte, []byte) (intersect, acount, bcount int64)
	AvxIntersectionCountsRight func([]byte, []byte) (intersect, bcount int64)
	X64Has                     func([]byte, int) bool
)

func init() {
	// cpuid.Flags()
	// flag.Parse()
	AvxPopCount = x64popcount // doesn't really use avx
	AvxIntersection = x64intersection
	AvxIntersectionCounts = x64intersectioncounts
	AvxIntersectionCountsRight = x64intersectioncountsright
	X64Has = x64has
	//* AVX-512 measured with no real boost PRE-TURIN (Zen3/pre-AVX512 and
	//* double-pumped-Zen4 era silicon), so it was disabled here. Turin (c4d,
	//* full-rate 512-bit) is now the primary fleet class — the audiencev3
	//* Rust kernels reinstate AVX-512 as a runtime-capability-selected peer
	//* path (detect once at startup, select 256/512-bit; older generations
	//* fall back to the 256-bit baseline). See audiencev2
	//* .planning/native-rewrite/designdocs/D3-kernels.md §3.
	// cpuid.Detect()
	// isAVX512F = cpuid.CPU.Supports(cpuid.AVX512F)
	// if isAVX512F {
	// 	log.Println("avxx512 supported")
	// 	AvxAnd = avx512and
	// 	AvxAndNot = x64andnot
	// 	AvxOr = avx512or
	// 	AvxNot = x64not
	// 	AvxOnes = x64ones
	// 	AvxZero = x64zero
	// 	return
	// }
	AvxAnd = x64and
	AvxAndNot = x64andnot
	AvxOr = x64or
	AvxNot = x64not
	AvxOnes = x64ones
	AvxZero = x64zero

}
