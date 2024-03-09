package creditcard

import (
	"regexp"
	"strings"
)

// IsValidNumber checks if a given credit card number is valid.
// Returns true if the number is valid, otherwise false.
func IsValidNumber(number string) bool {
	// It must start with 4, 5, or 6
	// It must contain exactly 16 digits
	// It must only consist of digits (0-9) and may have hyphens (-) at arbitrary places
	// It must not use any other separator like ' ' , '_', etc.
	// It must not have 4 or more consecutive repeated digits
	pattern := `^([456]\d{3})(-?\d{4}){3}$`
	regex := regexp.MustCompile(pattern)

	if !regex.MatchString(number) {
		return false
	}

	// Remove hyphens to check for consecutive repeated digits
	cleanNumber := strings.ReplaceAll(number, "-", "")

	// Check for 4 or more consecutive repeated digits
	for i := 0; i < len(cleanNumber)-3; i++ {
		if cleanNumber[i] == cleanNumber[i+1] && cleanNumber[i+1] == cleanNumber[i+2] && cleanNumber[i+2] == cleanNumber[i+3] {
			return false
		}
	}

	return true
}
