package main

import (
	"bufio"
	"fmt"
	"os"
	"github.com/softstone1/sothyvorn_Challenge/creditcard"
)

func main() {
	
fmt.Println("Credit Card Number Validator")
fmt.Println("Input Format:\nFirst line: Number of credit card numbers\nFollowing lines: Credit card numbers to validate")
fmt.Println("Output Format:\nValid or Invalid for each credit card number")
fmt.Println()
fmt.Println("Please enter the total number of credit card numbers followed by each number on a new line:")

scanner := bufio.NewScanner(os.Stdin)

var n int
if scanner.Scan() {
	fmt.Sscanf(scanner.Text(), "%d", &n)
}

if n <= 0 || n >= 100 {
	fmt.Println("The number of credit card numbers must be between 0 and 99.")
	return
}

results := make([]string, 0, n) 

    for i := 0; i < n && scanner.Scan(); i++ {
        creditCardNumber := scanner.Text()
        if creditcard.IsValidNumber(creditCardNumber) {
            results = append(results, "Valid")
        } else {
            results = append(results, "Invalid")
        }
    }

    fmt.Println("\nResults:")
    for _, result := range results {
        fmt.Println(result)
    }
}