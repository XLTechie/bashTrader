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
