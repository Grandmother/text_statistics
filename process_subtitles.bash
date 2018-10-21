input=${1}

if [[ $2 != "" ]]
then
	output=${2}
else
	ext="${input/*\.}"
	output=${input%\.*}_out.${ext}
fi

tmp=/tmp/subtitles_process0r.tmp

grep -ve "^[[:digit:]]" ${input} | grep [[:alpha:]] > ${tmp}

# replace split words by spaces
sed -i -e 's/\ /\n/g' ${tmp}

# remove dots, comas and empty lines
sed -i -e "s/[\.,\,,\",\?,\!,\-]*//g" ${tmp}
sed -i -e '/^[[:space:]]*$/d' ${tmp}

# make everytring lowercased
sed -i -e 's/\(.*\)/\L\1/' ${tmp}

# remove short words
sed -i -e '/^[[:alpha:]]\{1,3\}[[:space:]]*$/d' ${tmp}

# remove lines that starts from digits
sed -i -e '/^[[:digit:]].*[[:space:]]*$/d' ${tmp}
# remove words shorted with "'"
sed -i -e "/'/d" ${tmp}

sort ${tmp} > ${output}
uniq -c ${output} > ${tmp}
sort -n -k 1 ${tmp} > ${output}
