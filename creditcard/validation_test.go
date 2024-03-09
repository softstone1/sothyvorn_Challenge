package creditcard

import "testing"

func TestIsValidNumber(t *testing.T) {
    tests := []struct {
        number string
        want   bool
    }{
        {"4123456789123456", true},
        {"5123-4567-8912-3456", true},
        {"61234-567-8912-3456", false},
        {"4123356789123456", true},
        {"5133-3367-8912-3456", false},
        {"5123 - 3567 - 8912 - 3456", false},
    }

    for _, tt := range tests {
        if got := IsValidNumber(tt.number); got != tt.want {
            t.Errorf("isValidCreditCardNumber(%q) = %v, want %v", tt.number, got, tt.want)
        }
    }
}
