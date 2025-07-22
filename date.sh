#!/bin/bash
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
while read file; do
    while IFS= read -r date; do
        IFS='-' read -r -a arr <<< "$date"
        year=${arr[0]}
        month=${arr[1]}
        day=${arr[2]}
        month_name=${months[$month]}
        creation="${year} ${month_name}"
        if [[ -z ${month_arr[$creation]} ]]; then
            month_arr[$creation]=0
        
        
