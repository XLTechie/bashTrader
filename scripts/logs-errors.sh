# Logging and error handling functions
# e_error: a hard error.--print something and exit with given code or 255.
# e_warn: a warning, but we keep running.
# catchJSONMessage: looks for errors or alerts in the returned JSON, prints them, and clears the JSON

# Takes error text to be shown, and an optional exit code
function e_error {
echo 1>&2 "Error at line ${BASH_LINENO[$i]} of ${BASH_SOURCE[$i+1]}: $1"
# FixMe: should log something if logging is enabled
[[ -z "$2" ]] && exit 255
if [ "$2" -lt 1 -o "$2" -gt 255 ]; then
echo 1>2 "Additionally, a bad error exit code was given: $2"
exit 255
else exit $2
fi
}

function e_warn {
if [[ -z "$1" ]]; then
e_warn "A warning was issued, but no warning text was given."
else
echo 1>&2 "$1"
fi
}

# Looks for errors or alerts in the returned JSON, prints them, and clears the JSON.
# Returns true if it did anything, false if not.
function catchJSONMessage {
if [[ -n "``message``" ]]; then
echo "``message``"
``message.delete()``
``code.delete()``
tickVars -iln
return 0
else return 1
fi
}
