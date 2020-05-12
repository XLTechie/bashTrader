# simplePrint: prints a human friendly listing of the passed JSON object
# keySplitter: returns an array of the provided JSON key elements (subtracting TickTickisms)

# Simple no-op to prevent running in other than our expected environment
[ -z "$____bashTrader_is_running____" ] && { echo 1>&2 "This is meant to be included in bashTrader; exiting!"; exit 255; }

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
