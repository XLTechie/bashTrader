# Simple no-op to prevent running in other than our expected environment
[ -z "$____bashTrader_is_running____" ] && { echo 1>&2 "This is meant to be included in bashTrader; exiting!"; exit 255; }

# Requestors:
# Each one of these takes the following parameters, in this order:
# * Endpoint: a string including the part of the URL that serves as the endpoint for this transaction.
#	(N.B. FixMe: later this is intended to be a lookup table)
# * Request parameters: a string which is passed as part of the get request, initial "/" not required. Provide an empty string if none.
# * Callback: a function which receives the name of a JSON object as its first parameter, and does something about it.
# * Callback options: the rest of the parameters are given as options to the callback.

# Contains the JSON result of an artificial generic request, to be used in test mode
testModeData='{"testMode": "true","reality": "none","array": ["this","contains","nothing"],"object":{"having":"nothing","purpose":"none"}}'

# Sends a simple request
function r_simple {
local incoming

# Sanity checks
[ -z "$tradingURL" ] && e_error "Trading URL not set." 200

# Construct the URL from the base URL and the provided endpoint
URL="${tradingURL}/GET/V$1"
# Add the request parameters, if any
[ -n "$2" ] && URL+="/$2"
# FixMe: should log the URL here

# Submit the request, unless this is test mode, in which case don't
if [ -z "$testMode" ]; then
export APCA_API_BASE_URL APCA_API_KEY_ID APCA_API_SECRET_KEY
incoming=`curl $URL` || \
e_error "CURL failed!" 2
export -n APCA_API_BASE_URL APCA_API_KEY_ID APCA_API_SECRET_KEY
else # Generate fake data
incoming="$testModeData"
fi

# Convert our data into a usable JSON object
tickParse "$incoming"
}
