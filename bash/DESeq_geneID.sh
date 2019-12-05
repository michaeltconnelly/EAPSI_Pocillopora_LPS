#!/bin/bash
dir="/Users/mikeconnelly/computing/projects/EAPSI_Pocillopora_LPS"

awk -F "," '{print $1}' ${dir}/outputs/DESeq-results/tables/overall/res_LPS_ctrl.csv > ${dir}/outputs/DESeq-results/lists/res_LPS_ctrl_ID.txt
sed -i '' 1d ${dir}/outputs/DESeq-results/lists/res_LPS_ctrl_ID.txt
sed -i -e 's/"//g' ${dir}/outputs/DESeq-results/lists/res_LPS_ctrl_ID.txt
rm ${dir}/outputs/DESeq-results/lists/res_LPS_ctrl_ID.txt-e

awk -F "," '{print $1}' ${dir}/outputs/DESeq-results/tables/up/res_LPS_ctrl_up.csv > ${dir}/outputs/DESeq-results/lists/res_LPS_ctrl_up_ID.txt
sed -i '' 1d ${dir}/outputs/DESeq-results/lists/res_LPS_ctrl_up_ID.txt
sed -i -e 's/"//g' ${dir}/outputs/DESeq-results/lists/res_LPS_ctrl_up_ID.txt
rm ${dir}/outputs/DESeq-results/lists/res_LPS_ctrl_up_ID.txt-e

awk -F "," '{print $1}' ${dir}/outputs/DESeq-results/tables/down/res_LPS_ctrl_dn.csv > ${dir}/outputs/DESeq-results/lists/res_LPS_ctrl_dn_ID.txt
sed -i '' 1d ${dir}/outputs/DESeq-results/lists/res_LPS_ctrl_dn_ID.txt
sed -i -e 's/"//g' ${dir}/outputs/DESeq-results/lists/res_LPS_ctrl_dn_ID.txt
rm ${dir}/outputs/DESeq-results/lists/res_LPS_ctrl_dn_ID.txt-e
