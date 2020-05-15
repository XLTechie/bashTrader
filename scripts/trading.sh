# mkOrder: Constructs an order from known information and user input

# Simple no-op to prevent running in other than our expected environment
[[ -z "$____bashTrader_is_running____" ]] && { echo 1>&2 "This is meant to be included in bashTrader; exiting!"; exit 255; }

# With no options, returns the average quote.
# -b gets bid, -a gets ask, -c combined (quote, bid, ask)
# Behavior is undefined if more than one such option is provided, but only one number will be returned.
# Gets the global symbol, or asks for it.
function getQuote {
r_simpleData 1/last_quote/stocks "${symbol:-`getSymbol`}"
catchJSONMessage && return 1

OPTIND=1
while getopts :cab option; do	#{

case $option in	#{

c)
echo $(bc -l <<<"scale=2;(${__tick_data_last_bidprice}+${__tick_data_last_askprice})/2")" (${__tick_data_last_bidprice}-${__tick_data_last_askprice})"
;;

b)
echo ${__tick_data_last_bidprice}
;;

a)
echo ${__tick_data_last_askprice}
;;

*)
echo $(bc -l <<<"scale=2;(${__tick_data_last_bidprice}+${__tick_data_last_askprice})/2")
;;

esac	#}
done	#}

tickReset
}

# Constructs an order from known information and user input
# Parameters:
# side symbol type
function mkOrder {
local side sym type

# A symbol should have been passed in. If not, use the global symbol. If none, fail.
sym="${2:-$symbol}"
[[ -z "$sym" ]] && e_error "Attempted to build an order without a symbol!" 10

# Configure the side
if [[ "$1" == buy || "$1" == sell ]]; then #{
side="$1"
else	# Get the side #}{
while [[ "$side" != "buy" && "$side" != "sell" ]]; do #{
read -srN1 -p "Side: " side
echo
case "$side" in #{
b|B)
side=buy
echo 1>&2 ""
;;
s|S)
side=sell
echo 1>&2 ""
;;
c|C)
return	# Do not create an order
;;
*)
echo 1>&2 -e "\nB: buy, s: sell, or c: cancel."
;;
esac #}
done #}
fi #}

# Configure the type
if [[ "$3" == @(market|limit|stop|stop_limit) ]]; then #{
type="$3"
else	# Get the type #}{
while [[ "$type" != @(market|limit|stop|stop_limit) ]]; do #{
read -srN1 -p "type: " type
echo
case "$type" in #{
m|M)
type=market
;;
l|L)
type=limit
;;
t|T|b|B|s|S)
echo 1>&2 'Not implemented!'
;;
c|C)
return	# Do not create an order
;;
*)
echo 1>&2 "m: market, l: limit, s: stop, t: stop-limit, b: braket, or c: cancel."
;;
esac #}
done #}
fi #}

echo 1>&2 "side=$side, type=$type"
}
