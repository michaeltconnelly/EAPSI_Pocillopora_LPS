#!/bin/bash
result_dir="/Users/mikeconnelly/computing/projects/EAPSI_Pocillopora_LPS/outputs/DESeq-results/"
results="${result_dir}tables/*/*"

for result in $results
do
awk -F "," '{print $1}' ${result} > ${result}_ID.txt
sed -i '' 1d ${result}_ID.txt
sed -i -e 's/"//g' ${result}_ID.txt
rm ${result}_ID.txt-e
done

mv ${result_dir}tables/*/*.csv_ID.txt ${result_dir}lists/
