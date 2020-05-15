# simplePrint: prints a human friendly listing of the passed JSON object, using only the most RHS keys
# keySplitter: returns an array of the provided JSON key elements (subtracting TickTickisms)
# getSymbol: gets, or sets then gets, the working symbol

# Simple no-op to prevent running in other than our expected environment
[[ -z "$____bashTrader_is_running____" ]] && { echo 1>&2 "This is meant to be included in bashTrader; exiting!"; exit 255; }

#Takes the array we want to split into, and the key we want split
function keySplitter {
arrayName="$1"
shift
local IFS='_'

for word in ${1:12}; do
eval $arrayName=\(\""$word"\"\)
done
}

# Returns basic text structured in human readable form
# Takes the name of a JSON object to serialize, and a depth from the left to ignore (not implemented)
function simplePrint {
for item in ``$1.items()``; do
declare -a keys
keySplitter keys "$item"
# Print the most RHS key, and the value
echo "${keys[-1]}: ${!item}"
done
}

# If a symbol is set, it returns it on STDOUT.
# If no symbol is set (in $symbol from the parent environment), request one from the user.
# It also sets $symbol to whatever it gets, in case it is not being called in a subshell and that is desired.
# However the intended usage is: "${symbol:=`getSymbol`}"
# If the symbol appears to be an ID (longer than 10 characters), it is left alone. Otherwise it is forced to all caps.
function getSymbol {
declare -g symbol

# If the symble isn't already set, get it
while [[ -z "$symbol" ]]; do
read -rp "Symbol: " symbol _
done

# Capitalize if this looks like an ID
[[ ${#symbol} -lt 11 ]] && symbol="${symbol^^}"

echo "$symbol"
}
