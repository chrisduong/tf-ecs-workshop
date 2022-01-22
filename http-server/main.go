package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"

	"golang.org/x/mod/semver"
)

var Version = "v0.1.0-dev"

func main() {
	http.HandleFunc("/version", PrintVersion)

	//Use the default DefaultServeMux.
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatal(err)
	}
}

func PrintVersion(w http.ResponseWriter, r *http.Request) {
	if !semver.IsValid(Version) {
		fmt.Println("Not a valid semver")
		os.Exit(5)
	}
	io.WriteString(w, Version)
}
