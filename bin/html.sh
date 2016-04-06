#!/usr/bin/mksh
# Usage: html.sh file

# Constants - Use $var, Globals - Use ${var}
forig=${1} # Original file (for scripts)
conf=_www/config; PATH=$PATH:.

# Black magic, $1: file name (input)
abracadabra() {
  [ -f ${1%.*}.sh ] && . ${1%.*}.sh
  [ $? -eq 4 ] && echo "${body}" | sed '/${[A-Z]*}/ d; s|/index.html|/|g' && exit

  body=$([ -z "${body}" ] && cat $LAYOUT || sed -e "/\${CONTENT}$/ c\
$(echo "${body}"|sed '$! s/$/\\/')" $LAYOUT)

  for i in $(echo "${body}" | grep -o '${[A-Z]*}'); do # Variables: ${TITLE}
    [ -n "$(eval echo $i)" ] && body=$(echo "${body}"|sed "s&$i&$(eval echo "$i"|sed 's/\\/\\\\/g;s/&/\\\&/g')&g")
  done
}

d=$(dirname $1) # Greedy $conf sucker
while [ $(dirname $PWD) != $(realpath $PWD/$d) ]; do
  [ -f $PWD/$d/$conf ] && . $PWD/$d/$conf && abracadabra $1 || d=$d/..
done

body="$([ ${1##*.} = 'md' ] && cmark $1 || cat $1)" # Markdown -> HTML
LAYOUT=${LAYOUT:-${1}}; while :; do
  abracadabra ${LAYOUT} # Just do it!
done
