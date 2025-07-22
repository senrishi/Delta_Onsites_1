#!/bin/zsh

#traverse thru all the file types in the dir.

declare filetypes
while IFS= read -r ext; do
    if [[ ${#ext} -le 4 ]]; then
        filetypes+=("$ext")
    else
        filetypes+=("misc")
    fi
done < <(find . | sed 's/.*[.] *//')

declare -A filecount
IFS=$'\n' sorted_array=($(sort <<<"${filetypes[*]}")); unset IFS

temp_file=""
for i in "${sorted_array[@]}"; do
    if [[ "$i" != "$temp_file" ]]; then
        filecount["$i"]=1
    else
        ((filecount["$i"]++))
    fi
    temp_file="$i"
done

for i in "${!filecount[@]}"; do
    echo "$i: ${filecount[$i]}"
done

unset filetypes
unset filecount
unset sorted_array
unset temp_file