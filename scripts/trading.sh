# mkOrder: Constructs an order from known information and user input

# Simple no-op to prevent running in other than our expected environment
[[ -z "$____bashTrader_is_running____" ]] && { echo 1>&2 "This is meant to be included in bashTrader; exiting!"; exit 255; }

# Contains the JSON result of an artificial generic request, to be used in test mode
testModeData='{"testMode": "true","reality": "none","array": ["this","contains","nothing"],"object":{"having":"nothing","purpose":"none"}}'

# Constructs an order from known information and user input
mkOrder {
local sym side type

# A symbol should have been passed in. If not, use the global symbol. If none, fail.
sym="${1:-$symbol}"
[[ -z "$sym" ]] && e_error "Attempted to build an order without a symbol!" 10

if [[ "$1" == "buy" ]]; then
side=buy
elif [[ "$1" == "sell" ]]; then
side=sell
else	# Get the side
while [[ "$side" != "buy" && "$side" != "sell" ]]; do
read -srN1 -p "B)uy or S)ell?" side
case "$side" in
b|B)
side=buy
;;
s|S)
side=sell
;;
esac
done

# Limit, market, or stop?
while 

}
