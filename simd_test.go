package simd

import (
	"crypto/rand"
	"fmt"
	"log"
	"testing"
	"time"

	"github.com/kelindar/bitmap"
)

func Test_x64or(t *testing.T) {

	a := make([]byte, 31250000)
	b := make([]byte, 31250000)
	c := make([]byte, 31250000)
	d := make([]byte, 31250000)
	e := make([]byte, 31250000)
	f := make([]byte, 31250000)
	g := make([]byte, 31250000)
	h := make([]byte, 31250000)
	i := make([]byte, 31250000)
	target := make([]byte, 31250000)
	rand.Read(a)
	rand.Read(b)
	start := time.Now()
	for _, v := range [][]byte{b, c, d, e, f, g, h, i} {
		AvxOr(a, v, target)
	}
	elapsed := time.Since(start)
	log.Printf("elasped: %s\n", elapsed)
}

func Test_x64orAccuracy(t *testing.T) {
	a := []byte{73, 7, 84, 110, 38, 37, 58, 28, 101, 52, 89, 43, 2, 79, 112, 25, 89, 93, 35, 18, 15, 19, 95, 1, 60, 85, 83, 42, 84, 25, 60, 74, 22, 105, 48, 8, 93, 1, 95, 72, 58, 61, 74, 110, 71, 123, 17, 18, 41, 19, 104, 81, 126, 26, 62, 89, 4, 35, 35, 90, 123, 35, 46, 6, 12, 35, 31, 101, 90, 5, 38, 20, 102, 107, 127, 68, 61, 97, 60, 24, 107, 5, 62, 38, 43, 40, 111, 55, 0, 105, 85, 15, 24, 122, 47, 77, 116, 87, 18, 1, 12, 105, 22, 46, 26, 123, 76, 26, 73, 52, 52, 12, 115, 100, 8, 111, 38, 71, 122, 45, 73, 73, 27, 45, 94, 78, 112}
	b := []byte{63, 90, 114, 126, 28, 22, 1, 111, 44, 49, 98, 40, 43, 69, 30, 82, 8, 10, 125, 125, 125, 107, 8, 28, 41, 37, 109, 46, 82, 1, 44, 61, 87, 24, 61, 24, 3, 102, 1, 63, 89, 92, 73, 27, 57, 74, 109, 59, 11, 70, 32, 44, 61, 72, 26, 37, 15, 2, 64, 1, 96, 84, 115, 10, 113, 124, 12, 60, 22, 110, 97, 23, 32, 109, 30, 60, 119, 12, 83, 59, 85, 121, 27, 58, 4, 108, 123, 125, 119, 23, 99, 29, 54, 113, 108, 29, 108, 4, 15, 104, 89, 1, 90, 98, 30, 76, 81, 96, 0, 95, 97, 69, 86, 78, 88, 38, 118, 11, 75, 70, 9, 29, 38, 22, 125, 10, 8}
	c := []byte{127, 95, 118, 126, 62, 55, 59, 127, 109, 53, 123, 43, 43, 79, 126, 91, 89, 95, 127, 127, 127, 123, 95, 29, 61, 117, 127, 46, 86, 25, 60, 127, 87, 121, 61, 24, 95, 103, 95, 127, 123, 125, 75, 127, 127, 123, 125, 59, 43, 87, 104, 125, 127, 90, 62, 125, 15, 35, 99, 91, 123, 119, 127, 14, 125, 127, 31, 125, 94, 111, 103, 23, 102, 111, 127, 124, 127, 109, 127, 59, 127, 125, 63, 62, 47, 108, 127, 127, 119, 127, 119, 31, 62, 123, 111, 93, 124, 87, 31, 105, 93, 105, 94, 110, 30, 127, 93, 122, 73, 127, 117, 77, 119, 110, 88, 111, 118, 79, 123, 111, 73, 93, 63, 63, 127, 78, 120}
	target := make([]byte, 127)
	AvxOr(a, b, target)
	for n := range a {
		if target[n] != c[n] {
			fmt.Printf("%d not equal\n", n)
			t.FailNow()
		}
	}

}

func Test_x64and(t *testing.T) {

	a := make([]byte, 10000007)
	b := make([]byte, 10000007)
	c := make([]byte, 10000007)
	d := make([]byte, 10000007)
	e := make([]byte, 10000007)
	f := make([]byte, 10000007)
	g := make([]byte, 10000007)
	h := make([]byte, 10000007)
	i := make([]byte, 10000007)
	target := make([]byte, 10000007)
	rand.Read(a)
	rand.Read(b)
	start := time.Now()
	for _, v := range [][]byte{b, c, d, e, f, g, h, i} {
		AvxAnd(a, v, target)
	}
	elapsed := time.Since(start)
	log.Printf("elasped: %s\n", elapsed)
}

func Test_x64andAccuracy(t *testing.T) {
	a := []byte{73, 7, 84, 110, 38, 37, 58, 28, 101, 52, 89, 43, 2, 79, 112, 25, 89, 93, 35, 18, 15, 19, 95, 1, 60, 85, 83, 42, 84, 25, 60, 74, 22, 105, 48, 8, 93, 1, 95, 72, 58, 61, 74, 110, 71, 123, 17, 18, 41, 19, 104, 81, 126, 26, 62, 89, 4, 35, 35, 90, 123, 35, 46, 6, 12, 35, 31, 101, 90, 5, 38, 20, 102, 107, 127, 68, 61, 97, 60, 24, 107, 5, 62, 38, 43, 40, 111, 55, 0, 105, 85, 15, 24, 122, 47, 77, 116, 87, 18, 1, 12, 105, 22, 46, 26, 123, 76, 26, 73, 52, 52, 12, 115, 100, 8, 111, 38, 71, 122, 45, 73, 73, 27, 45, 94, 78, 112}
	b := []byte{63, 90, 114, 126, 28, 22, 1, 111, 44, 49, 98, 40, 43, 69, 30, 82, 8, 10, 125, 125, 125, 107, 8, 28, 41, 37, 109, 46, 82, 1, 44, 61, 87, 24, 61, 24, 3, 102, 1, 63, 89, 92, 73, 27, 57, 74, 109, 59, 11, 70, 32, 44, 61, 72, 26, 37, 15, 2, 64, 1, 96, 84, 115, 10, 113, 124, 12, 60, 22, 110, 97, 23, 32, 109, 30, 60, 119, 12, 83, 59, 85, 121, 27, 58, 4, 108, 123, 125, 119, 23, 99, 29, 54, 113, 108, 29, 108, 4, 15, 104, 89, 1, 90, 98, 30, 76, 81, 96, 0, 95, 97, 69, 86, 78, 88, 38, 118, 11, 75, 70, 9, 29, 38, 22, 125, 10, 8}
	c := []byte{9, 2, 80, 110, 4, 4, 0, 12, 36, 48, 64, 40, 2, 69, 16, 16, 8, 8, 33, 16, 13, 3, 8, 0, 40, 5, 65, 42, 80, 1, 44, 8, 22, 8, 48, 8, 1, 0, 1, 8, 24, 28, 72, 10, 1, 74, 1, 18, 9, 2, 32, 0, 60, 8, 26, 1, 4, 2, 0, 0, 96, 0, 34, 2, 0, 32, 12, 36, 18, 4, 32, 20, 32, 105, 30, 4, 53, 0, 16, 24, 65, 1, 26, 34, 0, 40, 107, 53, 0, 1, 65, 13, 16, 112, 44, 13, 100, 4, 2, 0, 8, 1, 18, 34, 26, 72, 64, 0, 0, 20, 32, 4, 82, 68, 8, 38, 38, 3, 74, 4, 9, 9, 2, 4, 92, 10, 0}
	target := make([]byte, 127)
	AvxAnd(a, b, target)
	for n := range a {
		if target[n] != c[n] {
			fmt.Printf("%d not equal\n", n)
			t.FailNow()
		}
	}

}

func Test_x64andnot(t *testing.T) {

	a := make([]byte, 10000007)
	b := make([]byte, 10000007)
	c := make([]byte, 10000007)
	d := make([]byte, 10000007)
	e := make([]byte, 10000007)
	f := make([]byte, 10000007)
	g := make([]byte, 10000007)
	h := make([]byte, 10000007)
	i := make([]byte, 10000007)
	target := make([]byte, 10000007)
	rand.Read(a)
	rand.Read(b)
	start := time.Now()
	for _, v := range [][]byte{b, c, d, e, f, g, h, i} {
		AvxAndNot(a, v, target)
	}
	elapsed := time.Since(start)
	log.Printf("elasped: %s\n", elapsed)
}

func Test_x64andnotAccuracy(t *testing.T) {
	a := []byte{73, 7, 84, 110, 38, 37, 58, 28, 101, 52, 89, 43, 2, 79, 112, 25, 89, 93, 35, 18, 15, 19, 95, 1, 60, 85, 83, 42, 84, 25, 60, 74, 22, 105, 48, 8, 93, 1, 95, 72, 58, 61, 74, 110, 71, 123, 17, 18, 41, 19, 104, 81, 126, 26, 62, 89, 4, 35, 35, 90, 123, 35, 46, 6, 12, 35, 31, 101, 90, 5, 38, 20, 102, 107, 127, 68, 61, 97, 60, 24, 107, 5, 62, 38, 43, 40, 111, 55, 0, 105, 85, 15, 24, 122, 47, 77, 116, 87, 18, 1, 12, 105, 22, 46, 26, 123, 76, 26, 73, 52, 52, 12, 115, 100, 8, 111, 38, 71, 122, 45, 73, 73, 27, 45, 94, 78, 112}
	b := []byte{63, 90, 114, 126, 28, 22, 1, 111, 44, 49, 98, 40, 43, 69, 30, 82, 8, 10, 125, 125, 125, 107, 8, 28, 41, 37, 109, 46, 82, 1, 44, 61, 87, 24, 61, 24, 3, 102, 1, 63, 89, 92, 73, 27, 57, 74, 109, 59, 11, 70, 32, 44, 61, 72, 26, 37, 15, 2, 64, 1, 96, 84, 115, 10, 113, 124, 12, 60, 22, 110, 97, 23, 32, 109, 30, 60, 119, 12, 83, 59, 85, 121, 27, 58, 4, 108, 123, 125, 119, 23, 99, 29, 54, 113, 108, 29, 108, 4, 15, 104, 89, 1, 90, 98, 30, 76, 81, 96, 0, 95, 97, 69, 86, 78, 88, 38, 118, 11, 75, 70, 9, 29, 38, 22, 125, 10, 8}
	c := []byte{64, 5, 4, 0, 34, 33, 58, 16, 65, 4, 25, 3, 0, 10, 96, 9, 81, 85, 2, 2, 2, 16, 87, 1, 20, 80, 18, 0, 4, 24, 16, 66, 0, 97, 0, 0, 92, 1, 94, 64, 34, 33, 2, 100, 70, 49, 16, 0, 32, 17, 72, 81, 66, 18, 36, 88, 0, 33, 35, 90, 27, 35, 12, 4, 12, 3, 19, 65, 72, 1, 6, 0, 70, 2, 97, 64, 8, 97, 44, 0, 42, 4, 36, 4, 43, 0, 4, 2, 0, 104, 20, 2, 8, 10, 3, 64, 16, 83, 16, 1, 4, 104, 4, 12, 0, 51, 12, 26, 73, 32, 20, 8, 33, 32, 0, 73, 0, 68, 48, 41, 64, 64, 25, 41, 2, 68, 112}
	target := make([]byte, 127)
	AvxAndNot(a, b, target)
	for n := range a {
		if target[n] != c[n] {
			fmt.Printf("%d not equal\n", n)
			t.FailNow()
		}
	}

}

func Test_x64not(t *testing.T) {

	a := make([]byte, 10000007)
	b := make([]byte, 10000007)
	c := make([]byte, 10000007)
	d := make([]byte, 10000007)
	e := make([]byte, 10000007)
	f := make([]byte, 10000007)
	g := make([]byte, 10000007)
	h := make([]byte, 10000007)
	i := make([]byte, 10000007)
	target := make([]byte, 10000007)
	rand.Read(a)
	rand.Read(b)
	start := time.Now()
	for _, v := range [][]byte{a, b, c, d, e, f, g, h, i} {
		AvxNot(v, target)
	}
	elapsed := time.Since(start)
	log.Printf("elasped: %s\n", elapsed)
}

func Test_x64notAccuracy(t *testing.T) {
	a := []byte{73, 7, 84, 110, 38, 37, 58, 28, 101, 52, 89, 43, 2, 79, 112, 25, 89, 93, 35, 18, 15, 19, 95, 1, 60, 85, 83, 42, 84, 25, 60, 74, 22, 105, 48, 8, 93, 1, 95, 72, 58, 61, 74, 110, 71, 123, 17, 18, 41, 19, 104, 81, 126, 26, 62, 89, 4, 35, 35, 90, 123, 35, 46, 6, 12, 35, 31, 101, 90, 5, 38, 20, 102, 107, 127, 68, 61, 97, 60, 24, 107, 5, 62, 38, 43, 40, 111, 55, 0, 105, 85, 15, 24, 122, 47, 77, 116, 87, 18, 1, 12, 105, 22, 46, 26, 123, 76, 26, 73, 52, 52, 12, 115, 100, 8, 111, 38, 71, 122, 45, 73, 73, 27, 45, 94, 78, 112}
	c := []byte{182, 248, 171, 145, 217, 218, 197, 227, 154, 203, 166, 212, 253, 176, 143, 230, 166, 162, 220, 237, 240, 236, 160, 254, 195, 170, 172, 213, 171, 230, 195, 181, 233, 150, 207, 247, 162, 254, 160, 183, 197, 194, 181, 145, 184, 132, 238, 237, 214, 236, 151, 174, 129, 229, 193, 166, 251, 220, 220, 165, 132, 220, 209, 249, 243, 220, 224, 154, 165, 250, 217, 235, 153, 148, 128, 187, 194, 158, 195, 231, 148, 250, 193, 217, 212, 215, 144, 200, 255, 150, 170, 240, 231, 133, 208, 178, 139, 168, 237, 254, 243, 150, 233, 209, 229, 132, 179, 229, 182, 203, 203, 243, 140, 155, 247, 144, 217, 184, 133, 210, 182, 182, 228, 210, 161, 177, 143}
	target := make([]byte, 127)
	AvxNot(a, target)
	for n := range a {
		if target[n] != c[n] {
			fmt.Printf("%d not equal\n", n)
			t.FailNow()
		}
	}

}

func GetBitMap(a []byte) (b bitmap.Bitmap) {
	remain := len(a) % 8
	if remain > 0 {
		remain = 8 - remain
		for x := 0; x < remain; x++ {
			a = append(a, 0)
		}
	}
	b = bitmap.FromBytes(a)
	return
}

func Test_bitmap(t *testing.T) {
	a := make([]byte, 31250007)
	c := make([]byte, 31250007)
	d := make([]byte, 31250007)
	e := make([]byte, 31250007)
	f := make([]byte, 31250007)
	g := make([]byte, 31250007)
	h := make([]byte, 31250007)
	i := make([]byte, 31250007)
	b := make([]byte, 31250007)
	// target := make([]byte, 31250000)
	rand.Read(a)
	rand.Read(b)
	rand.Read(c)
	rand.Read(d)
	rand.Read(e)
	rand.Read(f)
	rand.Read(g)
	rand.Read(h)
	rand.Read(i)

	start := time.Now()
	_a := GetBitMap(a)
	for _, v := range [][]byte{b, c, d, e, f, g, h, i} {
		_v := GetBitMap(v)
		_a.And(_v)
		//AvxAnd(a, v, target)
	}
	elapsed := time.Since(start)
	log.Printf("elasped: %s\n", elapsed)

}

func Test_mybitmap(t *testing.T) {
	a := make([]byte, 31250007)
	c := make([]byte, 31250007)
	d := make([]byte, 31250007)
	e := make([]byte, 31250007)
	f := make([]byte, 31250007)
	g := make([]byte, 31250007)
	h := make([]byte, 31250007)
	i := make([]byte, 31250007)
	b := make([]byte, 31250007)
	//target := make([]byte, 31250000)
	rand.Read(a)
	rand.Read(b)
	rand.Read(c)
	rand.Read(d)
	rand.Read(e)
	rand.Read(f)
	rand.Read(g)
	rand.Read(h)
	rand.Read(i)

	start := time.Now()
	for _, v := range [][]byte{b, c, d, e, f, g, h, i} {
		AvxAnd(a, v, a)
	}
	elapsed := time.Since(start)
	log.Printf("elasped: %s\n", elapsed)

}

func Test_x64onesAccuracy(t *testing.T) {
	a := []byte{73, 7, 84, 110, 38, 37, 58, 28, 101, 52, 89, 43, 2, 79, 112, 25, 89, 93, 35, 18, 15, 19, 95, 1, 60, 85, 83, 42, 84, 25, 60, 74, 22, 105, 48, 8, 93, 1, 95, 72, 58, 61, 74, 110, 71, 123, 17, 18, 41, 19, 104, 81, 126, 26, 62, 89, 4, 35, 35, 90, 123, 35, 46, 6, 12, 35, 31, 101, 90, 5, 38, 20, 102, 107, 127, 68, 61, 97, 60, 24, 107, 5, 62, 38, 43, 40, 111, 55, 0, 105, 85, 15, 24, 122, 47, 77, 116, 87, 18, 1, 12, 105, 22, 46, 26, 123, 76, 26, 73, 52, 52, 12, 115, 100, 8, 111, 38, 71, 122, 45, 73, 73, 27, 45, 94, 78, 112}
	//target := make([]byte, 127)
	AvxOnes(a)
	for n := range a {
		if a[n] != 255 {
			fmt.Printf("%d not equal\n", n)
			t.FailNow()
		}
	}
	count := AvxPopCount(a)
	if count != 1016 {
		t.FailNow()
	}
}

func Test_x64zeroAccuracy(t *testing.T) {
	a := make([]byte, 1356)
	rand.Read(a)
	AvxZero(a)
	for n := range a {
		if a[n] != 0 {
			fmt.Printf("%d not equal\n", n)
			t.FailNow()
		}
	}

}

func Test_x64popcountAccuracy(t *testing.T) {
	a := []byte{16, 9, 3, 1}
	count := AvxPopCount(a)
	if count != 6 {
		t.Fail()
	}
}

func Test_avxpopcount(t *testing.T) {
	a := make([]byte, 31250007)
	c := make([]byte, 31250007)
	d := make([]byte, 31250007)
	e := make([]byte, 31250007)
	f := make([]byte, 31250007)
	g := make([]byte, 31250007)
	h := make([]byte, 31250007)
	i := make([]byte, 31250007)
	b := make([]byte, 31250007)
	//target := make([]byte, 31250000)
	rand.Read(a)
	rand.Read(b)
	rand.Read(c)
	rand.Read(d)
	rand.Read(e)
	rand.Read(f)
	rand.Read(g)
	rand.Read(h)
	rand.Read(i)

	start := time.Now()
	total := int64(0)
	for _, v := range [][]byte{a, b, c, d, e, f, g, h, i} {
		total += AvxPopCount(v)
	}
	elapsed := time.Since(start)
	log.Printf("pop count elasped: %s\n", elapsed)
	log.Printf("total: %d\n", total)

	args := []bitmap.Bitmap{}
	for _, v := range [][]byte{a, b, c, d, e, f, g, h, i} {
		args = append(args, GetBitMap(v))
	}

	start = time.Now()
	total = 0
	for _, v := range args {

		total += int64(v.Count())
	}
	elapsed = time.Since(start)
	log.Printf("bitmap count elasped: %s\n", elapsed)
	log.Printf("total: %d\n", total)
}

func Test_And(t *testing.T) {
	a := make([]byte, 999001)
	b := make([]byte, 999001)
	rand.Read(a)
	rand.Read(b)
	AvxAndNot(a, b, a)
	fmt.Printf("bits: %d\n", AvxPopCount(a))

}

var abytes []byte
var bbytes []byte
var cbytes []byte
var (
	a, b, c, d, e, f, g, h, i, target []byte
)

func init() {
	abytes = make([]byte, 240000009)
	bbytes = make([]byte, 240000009)

	rand.Read(abytes)
	rand.Read(bbytes)
	a = make([]byte, 31250007)
	c = make([]byte, 31250007)
	d = make([]byte, 31250007)
	e = make([]byte, 31250007)
	f = make([]byte, 31250007)
	g = make([]byte, 31250007)
	h = make([]byte, 31250007)
	i = make([]byte, 31250007)
	b = make([]byte, 31250007)
	target = make([]byte, 31250007)
	// target := make([]byte, 31250000)
	rand.Read(a)
	rand.Read(b)
	rand.Read(c)
	rand.Read(d)
	rand.Read(e)
	rand.Read(f)
	rand.Read(g)
	rand.Read(h)
	rand.Read(i)
}

func Test_Intersect256(t *testing.T) {
	a := []byte{4, 4, 4, 4, 4, 4, 4, 4,
		4, 4, 4, 4, 4, 4, 4, 4,
		4, 4, 4, 4, 4, 4, 4, 4,
		4, 4, 4, 4, 4, 4, 4, 4,
		4, 4, 4, 4, 4, 4, 4, 4,
		4, 4, 4, 4, 4, 4, 4, 4,
		4, 4, 4, 4, 4, 4, 4, 4,
		4, 4, 4, 4, 4, 4, 4, 4,
		0}

	count := AvxIntersection(a, a)
	if count != 64 {
		t.Fail()
	}
}
func Test_Intersection(t *testing.T) {
	target := make([]byte, len(abytes))
	icount := AvxIntersection(abytes, bbytes)
	AvxAnd(abytes, bbytes, target)
	acount := AvxPopCount(target)
	if acount != icount {
		t.Fail()
	}

}

func BenchmarkAnd(b *testing.B) {
	cbytes = make([]byte, 240000009)
	AvxAnd(abytes, bbytes, cbytes)
	AvxPopCount(cbytes)
}

func BenchmarkIntersection(b *testing.B) {
	AvxIntersection(abytes, bbytes)
}

func TestIntersection(T *testing.T) {
	a := make([]byte, 31250007)
	c := make([]byte, 31250007)
	d := make([]byte, 31250007)
	e := make([]byte, 31250007)
	f := make([]byte, 31250007)
	g := make([]byte, 31250007)
	h := make([]byte, 31250007)
	i := make([]byte, 31250007)
	b := make([]byte, 31250007)
	target := make([]byte, 31250007)
	// target := make([]byte, 31250000)
	rand.Read(a)
	rand.Read(b)
	rand.Read(c)
	rand.Read(d)
	rand.Read(e)
	rand.Read(f)
	rand.Read(g)
	rand.Read(h)
	rand.Read(i)
	start := time.Now()
	total := int64(0)
	for _, v := range [][]byte{a, b, c, d, e, f, g, h, i} {
		for _, z := range [][]byte{a, b, c, d, e, f, g, h, i} {
			AvxAnd(v, z, target)
			total += AvxPopCount(target)
		}
	}
	elapsed := time.Since(start)
	log.Printf("and/PopCount elasped: %s\n", elapsed)
	log.Printf("total: %d\n", total)
	start = time.Now()
	total = int64(0)
	for _, v := range [][]byte{a, b, c, d, e, f, g, h, i} {
		for _, z := range [][]byte{a, b, c, d, e, f, g, h, i} {
			total += AvxIntersection(v, z)
		}
	}
	elapsed = time.Since(start)
	log.Printf("Intersection elasped: %s\n", elapsed)
	log.Printf("total: %d\n", total)

}

func BenchmarkIntersectionA(ba *testing.B) {
	for _, v := range [][]byte{a, b, c, d, e, f, g, h, i} {
		for _, z := range [][]byte{a, b, c, d, e, f, g, h, i} {
			AvxAnd(v, z, target)
			AvxPopCount(target)
		}
	}

}

func BenchmarkIntersectionB(ba *testing.B) {
	for _, v := range [][]byte{a, b, c, d, e, f, g, h, i} {
		for _, z := range [][]byte{a, b, c, d, e, f, g, h, i} {
			AvxIntersection(v, z)
		}
	}

}
