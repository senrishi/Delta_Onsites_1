# #!/bin/bash

#traverse thru all the file types in the dir.

declare filetypes
while IFS= read -r ext; do
    if [[ ${#ext} -le 3 ]]
    then
        filetypes+=("$ext")
    else
        filetypes+=("misc")
    fi
done < <(find . | grep -v / | sed 's/.*[.] *//')
declare -A filecount
count=0


# get_extensions() {
#     for filename in *; do
#         # Skip if not a regular file
#         [[ -f "$filename" ]] || continue
#         ext="${filename##*.}"
#         if [[ "$filename" != "$ext" && ${#ext} -le 3 ]]; then
#             echo "$ext"
#         fi
#     done
# }
# get_extensions | sort | uniq -c | while read count ext; do
#     echo "$ext: $count"
# done