#!/bin/bash
# 
# A wrapper script to invoke XmlLint over a directory of files.
# Takes a directory name as an optional argument, but otherwise
# runs in the current directory.
# 
# Provides XmlLint with an element to retrieve when run, and
# outputs matching elements and their contents into a file
# named after the element.
# 
# If the XPath expression doesn't find corresponding elements
# the filename is added to a "missing" file.
# 
# Composed for an EAD Finding Aid analysis project.

if [ "$1" ]; then
	dir=$1
else
	dir="."
fi
if [ "$(ls "$dir"/*.xml)" ]; then
	echo -e "Enter the element to retrieve: \c "
	read -r  ename
	tempfile=$(mktemp)
	for i in "$dir"/*.xml
	do
		xmllint --xpath "//*[local-name()='$ename']" "$i" >> "$tempfile"
		status=$?
		if [ $status -ne 0 ]; then
			echo "No match in $i" >> "$dir"/missing-"$ename".txt
		fi
	awk '{$1=$1};1' "$tempfile" > "$dir"/"$ename".txt
	done
	rm "${tempfile}"
fi
echo "Done."

