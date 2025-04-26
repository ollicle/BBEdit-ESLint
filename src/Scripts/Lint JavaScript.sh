#!/bin/sh

# Test npm, eslint are available
# If not output infos

# Test bbresults is available
# If not output instruction

# map file,line,col,type,msg from eslint compact format
FORMAT_COMPACT="(?P<file>.+?): line (?P<line>\d+), (col (?P<col>\d+),)? (?P<type>[a-zA-z]+) - (?P<msg>.*)$"

# determine parent directory of file
DIR="$(dirname "${BB_DOC_PATH}")"

# move to current directory to provide context for npm
cd "$DIR" || { echo "Unable to 'cd \"$DIR\"'" ; exit 1 ; }

# check for eslint
hash eslint > /dev/null 2>&1 || { echo "eslint not installed" ; exit 1 ; }

# Run eslint in npm project (requires 'eslint-formatter-compact'
# Install that manually with `npm install -D eslint-formatter-compact`
RESPONSE=$("$(which eslint)" "$BB_DOC_PATH" --format compact)

CHARCOUNT="${#RESPONSE}"

# eslint output of one character indicates no problems
if [ "$CHARCOUNT" -gt 1 ]
then
	# head (get first line only)
	# grep -c (get the count of lines starting with: BB_DOC_PATH)
	RESULT=$(echo "${RESPONSE}" | head -n 1 | grep -c "^$BB_DOC_PATH")

	if [ "$RESULT" -eq 1 ]
	then
		# expected eslint output - pass it to bbresults
		echo "${RESPONSE}" | bbresults --pattern "$FORMAT_COMPACT"

	else
		# unexpected output - pass it to STDOUT
		echo "Oops! Perhaps eslint output has changed. Please report https://github.com/ollicle/BBEdit-ESLint/issues/"
		echo "RESPONSE ${RESPONSE}"
		echo "CHARCOUNT $CHARCOUNT"
		echo "RESULT $RESULT"
		exit 1
	fi
fi
