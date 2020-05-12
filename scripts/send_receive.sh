# Simple no-op to prevent running in other than our expected environment
[ -z "$____bashTrader_is_running____" ] && { echo 1>&2 "This is meant to be included in bashTrader; exiting!"; exit 255; }

# Requestors:
# Each one of these takes the following parameters, in this order:
# * Endpoint: a string including the part of the URL that serves as the endpoint for this transaction.
#	(N.B. FixMe: later this is intended to be a lookup table)
# * Request parameters: a string which is passed as part of the get request, initial "&" not required. Provide an empty string if none.
# * Callback: a function which receives the incoming JSON on its STDIN, and does something with it.
# * Callback options: the rest of the parameters are given as options to the callback.

# Sends a simple request, with no parameters
function r_simple {
# Sanity checks
[ -z "$trading_url" ] && e_error "Trading URL not set." 200
}
