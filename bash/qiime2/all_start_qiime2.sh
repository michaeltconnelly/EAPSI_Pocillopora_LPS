#!/bin/bash
#purpose: create directory structure, copy program binaries and reference sequences on local computer
#conda activate qiime2-2020.2

prodir="/Users/mikeconnelly/computing/projects/EAPSI_Pocillopora_LPS"
exp="LPS"
EAPSIsamples="Wt1-3a Wt1-3b Wt1-3c Wt1-6a Wt1-6b Wt1-6c Wt2-3a Wt2-3b Wt2-3c Wt2-6a Wt2-6b Wt2-6c Hw1-3a Hw1-3b Hw1-3c Hw1-6a Hw1-6b Hw1-6c Hw2-3a Hw2-3b Hw2-3c Hw2-6a Hw2-6b Hw2-6c"
echo "Pipeline setup process started"

#make file structure for pipeline file input/output
mkdir ${prodir}/outputs/qiime2
mkdir ${prodir}/outputs/qiime2/qza
mkdir ${prodir}/outputs/qiime2/qzv
mkdir ${prodir}/outputs/qiime2/QC
mkdir ${prodir}/outputs/qiime2/export_silva

bash ${prodir}/bash/qiime2/all_importqc_qiime2.sh
