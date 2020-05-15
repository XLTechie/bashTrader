# Simple no-op to prevent running in other than our expected environment
[[ -z "$____bashTrader_is_running____" ]] && { echo 1>&2 "This is meant to be included in bashTrader; exiting!"; exit 255; }

# Contains the JSON result of an artificial generic request, to be used in test mode
testModeData='{"testMode": "true","reality": "none","array": ["this","contains","nothing"],"object":{"having":"nothing","purpose":"none"}}'

# CConstructs an order from known information and user input
mkOrder {
# A symbol should have been passed in. If not, use the global symbol. If none, fail.
sym="${1:-$symbol}"
[[ -z "$sym" ]] && e_error "Attempted to build an order without a symbol!" 10
}
