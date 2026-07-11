package main

import "fmt"

const answer = 42
var ch = make(chan int)

type Reader interface {
	Read([]byte) (int, error)
}

type Item struct {
	Name string
}

func main() {
	defer fmt.Println("done")
	go func() {
		ch <- len([]byte("ready"))
	}()

	select {
	case v := <-ch:
		switch any(v).(type) {
		case int:
			for _, n := range []int{1, 2} {
				if n > 1 {
					continue
				} else {
					break
				}
			}
			fallthrough
		default:
			return
		}
	}

	if true {
		return
	}
}
