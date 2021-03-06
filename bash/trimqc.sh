#!/bin/bash
#./bash/trimqc.sh
#purpose: quality checking of trimmed RNAseq reads using FASTQC on Pegasus compute node
#To start this job from the EAPSI_Pocillopora_LPS directory, use:
#bsub -P transcriptomics < /scratch/projects/transcriptomics/mikeconnelly/projects/EAPSI_Pocillopora_LPS/bash/trimqc.sh

#BSUB -J trimqc
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -o trimqc%J.out
#BSUB -e trimqc%J.err
#BSUB -n 8
#BSUB -u mconnelly@rsmas.miami.edu
#BSUB -N

##specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
prodir="/scratch/projects/transcriptomics/mikeconnelly/projects/EAPSI_Pocillopora_LPS"
exp="LPS"
EAPSIsamples="Wt1-3a Wt1-3b Wt1-3c Wt1-6a Wt1-6b Wt1-6c Wt2-3a Wt2-3b Wt2-3c Wt2-6a Wt2-6b Wt2-6c Hw1-3a Hw1-3b Hw1-3c Hw1-6a Hw1-6b Hw1-6c Hw2-3a Hw2-3b Hw2-3c Hw2-6b Hw2-6c"

module load java/1.8.0_60
${mcs}/programs/FastQC/fastqc \
${prodir}/outputs/trimmomaticreads/[HW][wt][12]-[123456][abc]*fastq.gz \
--outdir ${prodir}/outputs/trimqcs/
