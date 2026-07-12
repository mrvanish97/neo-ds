package main

import "fmt"

const answer = 42
var ch = make(chan int)

type Reader interface {
	Read([]byte) (int, error)
}

type Item struct {
	Name string `json:"name"`
	Count int
}

type Box struct {
	Items map[string]Item
}

func (b *Box) Add(name string, count int) {
	if b.Items == nil {
		b.Items = make(map[string]Item)
	}
	b.Items[name] = Item{Name: name, Count: count}
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

	box := &Box{}
	box.Add("first", 1)
	for name, item := range box.Items {
		fmt.Println(name, item.Count)
	}
}
