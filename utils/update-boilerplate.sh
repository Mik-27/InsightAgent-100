#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# agent/../utils/update-boilerplate -> push changes in current folder to template
PULL_FROM="${1:-$(find $(pwd) -type f -name *.py)}"
PUSH_TO=$(echo "$1/../../template/insightagent-boilerplate.py" | sed -e :a -e 's,[^/]*/\.\.\/,,' -e ta)
if [[ "${PULL_FROM}" =~ boilerplate ]];
then
    PUSH_TO="$2"
fi

# string to search for
MARKER="### START_BOILERPLATE ###"

# get the boilerplate portion of the script
BOILERPLATE=$(cat "${PULL_FROM}" | grep "${MARKER}" -m1 -A $(cat "${PULL_FROM}" | wc -l))

# get the header portion of the boilerplate
HEADER=$(cat "${PUSH_TO}" | grep "${MARKER}" -m1 -B $(cat "${PUSH_TO}" | wc -l) | sed -e '$ d')

echo "Stitching together"
mv "${PUSH_TO}" "${PUSH_TO}.old"
cat <<EOF > "${PUSH_TO}"
${HEADER}
${BOILERPLATE}
EOF

echo "Please review '${PUSH_TO}'"
echo "Remove the backup when you're done:"
echo "$ rm -f ${PUSH_TO}.old"
echo "$ git add ${PUSH_TO}"
