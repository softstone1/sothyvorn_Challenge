package main

import (
	"crypto/tls"
	"net/http"
	"testing"
)

func TestHTTPSToHTTPRedirect(t *testing.T) {
	// Skipping certificate verification for self-signed certs
	http.DefaultTransport.(*http.Transport).TLSClientConfig = &tls.Config{InsecureSkipVerify: true}

	resp, err := http.Get("https://ec2-54-159-135-51.compute-1.amazonaws.com/")
	if err != nil {
		t.Fatalf("Failed to make request: %v", err)
	}
	if resp.StatusCode != http.StatusOK {
		t.Errorf("Expected status code 200, got %d", resp.StatusCode)
	}
	if resp.Request.URL.Scheme != "https" {
		t.Errorf("Expected request to be redirected to HTTPS, but scheme is %s", resp.Request.URL.Scheme)
	}
}
