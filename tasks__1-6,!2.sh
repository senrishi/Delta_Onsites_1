#!/bin/zsh

declare -A month_arr
declare -A months=(
    [01]="January"
    [02]="February"
    [03]="March"
    [04]="April"
    [05]="May"
    [06]="June"
    [07]="July"
    [08]="August"
    [09]="September"
    [10]="October"
    [11]="November"
    [12]="December"
)

date="`date +%Y%m%d%H%M%S`";
touch "report_$date.txt"
user_count=0
owner_count=0
miscallenoeus=0

while IFS= read -r file; do
    date_str=$(stat "$file" | grep Modify | awk '{print $2}')

    if [[ -z "$date_str" ]]; then
        continue
    fi

    IFS='-' read -r -a arr <<< "$date_str"
    year=${arr[0]}
    month_num=${arr[1]}
    month_name=${months[$month_num]}
    key="$month_name $year"
    ((month_arr["$key"]++))


    # permission=$(stat -c '%A %a %n' "$file" | awk '{print $2}')
    permission=$(stat -c '%A %a %n' "$file" | awk '{print $2}')
    if [[ $permission == "777" ]]; then
        ((user_count++))
    elif [[ $permission == "700" ]]; then
        ((owner_count++))
    else
        ((miscallenoeus++))
    fi


done < <(find . -type f)

echo "Monthly file counts:"
for i in "${!month_arr[@]}"; do
    echo "$i: ${month_arr[$i]}"
done
echo -e "\n\nMost modified file months :\n\n"

mapfile -t arr2 < <(
    for key in "${!month_arr[@]}"; do
        echo "${month_arr[$key]} $key"
        arr2+=("$key")
    done | sort -rn | head -5 |
    cut -d ' ' -f2-
)

#-------------------------------------------------------
#
#
for i in "${arr2[@]}"
do
    echo "$i"
done
declare -A month1 month2 month3 month4 month5


for i in "${!arr2[@]}"; do
    while IFS= read -r file; do
        date_str=$(stat "$file" | grep Modify | awk '{print $2}')

        if [[ -z "$date_str" ]]; then
            continue
        fi

        IFS='-' read -r -a arr <<< "$date_str"
        year=${arr[0]}
        month_num=${arr[1]}
        month_name=${months[$month_num]}
        key="$month_name $year"
        if [[ "$key" == "${arr2[$i]}" ]]; then
            filesize=$(stat "$file" | grep Size | awk '{print $2}')
            if [[ $i -eq 0 ]]; then
                month1[$file]=$filesize
            elif [[ $i -eq 1 ]]; then
                month2[$file]=$filesize
            elif [[ $i -eq 2 ]]; then
                month3[$file]=$filesize
            elif [[ $i -eq 3 ]]; then
                month4[$file]=$filesize
            elif [[ $i -eq 4 ]]; then
                month5[$file]=$filesize
            fi
        fi

    done < <(find . -type f)
done

echo -e "\nStats for ${arr2[0]}:\n "

for key in "${!month1[@]}"; do
    echo -e "\n$key : ${month1[$key]} bytes"
done | sort -rn | head -5

echo -e "\nStats for ${arr2[1]}:\n "

for key in "${!month2[@]}"; do
    echo -e "\n$key : ${month2[$key]} bytes"
done | sort -rn | head -5

echo -e "\nStats for ${arr2[2]}:\n "

for key in "${!month3[@]}"; do
    echo -e "\n$key : ${month3[$key]} bytes"
done | sort -rn | head -5

echo -e "\nStats for ${arr2[3]}:\n "

for key in "${!month4[@]}"; do
    echo -e "\n$key : ${month4[$key]} bytes"
done | sort -rn | head -5

echo -e "\nStats for ${arr2[4]}:\n "
for key in "${!month5[@]}"; do
    echo -e "\n$key : ${month5[$key]} bytes"
done | sort -rn | head -5



#-------------------------------------------------------
# stat -c '%A %a %n' date.sh | awk '{print $2}'


echo -e "\n\nNumber of files that users have full permissions to : $user_count"
echo -e "\nNumber of files that owners have full permissions to : $owner_count"
echo -e "\nRandom permissions : $miscallenous"

unset month_arr
unset months
unset top_five
unset arr2
unset month1
unset month2
unset month3
unset month4
unset month5
