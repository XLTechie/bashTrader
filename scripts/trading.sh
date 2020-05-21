# mkOrder: Constructs an order from known information and user input
# getQuote: returns basic quote(s) for the current symbol

# Simple no-op to prevent running in other than our expected environment
[[ -z "$____bashTrader_is_running____" ]] && { echo 1>&2 "This is meant to be included in bashTrader; exiting!"; exit 255; }

# With no options, returns the average quote.
# -b gets bid, -a gets ask, -c combined (quote, bid, ask)
# Behavior is undefined if more than one such option is provided, but only one number will be returned.
# Uses the global symbol, or fails.
function getQuote {
if [[ -z "$symbol" ]]; then	#{
e_warn "Requested a quote with no symbol"
return 1
fi	#}

r_simpleData 1/last_quote/stocks "$symbol"
catchJSONMessage && return

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
local side sym type qty price 

# We need this for patterns, but can't accidentally leave it on--Ticktick doesn't like it for some reason
shopt -s extglob
trap "shopt -u extglob" RETURN

# q)uantity, b)uy, s)ell, M)arket, L)imit (price), S)top
OPTIND=1
while getopts "q:bsML:S" option; do #{

case $option in #{

b) # buy
side=buy
;;

s) # Sell
side=sell
;;

q)	# Quantity
if [[ "$OPTARG" =~ ^[1-9][0-9]*$ ]]; then #{
qty=$OPTARG
else	#}{
e_warn "$Invalid quantity ($OPTARG)."
fi	#}
;;

M)	# Type: market
readonly type=market
;;

L)	# Type: limit
readonly type=limit
priceRequired=yes
price="$OPTARG"	# This is checked for pricyness later
;;

S)	# Type: stop
type=stop
;;

esac #}
done #}

# Configure the symbol, which may have been passed as an option
if [[ -n "${!OPTIND}" ]]; then # A potential symbol was passed in #{
sym="${!OPTIND}"
else	# It wasn't passed in; get  from environment #}{
sym="$symbol"
fi	#}
[[ -z "$sym" ]] && e_error "Attempted to build an order without a symbol!" 10

# If quantity wasn't set, get it
while [[ ! $qty =~ ^[1-9][0-9]*$ ]]; do	#{
read -rp "Quantity: " qty _
done	#}

# If side wasn't set by options, configure the side
while [[ "$side" != @(buy|sell) ]]; do #{
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

# Configure the type if it wasn't set by options
while [[ "$type" != @(market|limit|stop|stop_limit) ]]; do #{
read -srN1 -p "type: " type
echo
case "$type" in #{
m|M)
type=market
;;
l|L)
type=limit
priceRequired=yes
;;
t|T|b|B|s|S)
echo 1>&2 'Not implemented!'
unset type
;;
c|C)
unset type
return	# Do not create an order
;;
*)
unset type
echo 1>&2 "m: market, l: limit, s: stop, t: stop-limit, b: braket, or c: cancel."
;;
esac #}
done #}

# For a market order, we don't set a price. For everything else, we require one be passed or provided.
if [[ -n "$priceRequired" ]]; then	#{
# Check the price for pricyness, and if it doesn't look right, ask for it
while [[ ! "$price" =~ ^[0-9]+(\.[0-9]{1,4})?$ ]]; do	#{
echo 1>&2 "$symbol: `getQuote -c`"
read -rp "Limit price: " price _
done	#}
fi	#}

# We now have enough information to construct the order
# At the moment, we do that by printing it to the caller
printf '{
"symbol": "%s",
"qty": %s,
"side": "%s",
"type": "%s",
"time_in_force": "%s",
"extended_hours": %s,
"order_class": "%s"%b%b%b
}' $symbol $qty $side $type ${timeInForce:-day} ${extendedHours:-false} ${class:-simple} \
${price:+",\n\"limit_price\": \"$price\""} ${stop:+",\n\"stop_price\": \"$stop\""} ${myOrderID:+",\n\"client_order_id\": \"$myOrderID\""} 

# order_class: simple, bracket, oco or oto
#take_profit { limit_price, stop_loss { stop_price, limit_price } }
# Things to be configured later
#day, gtc, opg, cls, ioc, fok

}
