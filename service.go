package main

import (
	"fmt"
	"net/http"
)

func sayHello(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "hello web!!!\n")
}

func main() {
	http.HandleFunc("/", sayHello)
	err := http.ListenAndServe(":8088", nil)
	if err != nil {
		fmt.Println("listen and server: ", err)
	}
}
