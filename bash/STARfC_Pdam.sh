#!/bin/bash
#./bash/STARfC_Pdam.sh
#purpose: quantify Pocillopora damicornis aligned RNAseq transcript abundances using featureCounts program to create a counts table on Pegasus
#To start this job from the EAPSI_Pocillopora_LPS directory, use:
#bsub -P transcriptomics < /scratch/projects/transcriptomics/mikeconnelly/projects/EAPSI_Pocillopora_LPS/bash/STARfC_Pdam.sh

#BSUB -J starfC_pdam
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -o starfC_pdam%J.out
#BSUB -e starfC_pdam%J.err
#BSUB -n 16
#BSUB -W 6:00
#BSUB -u mconnelly@rsmas.miami.edu
#BSUB -N

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
coldir="/scratch/projects/transcriptomics/mikeconnelly/sequences/EAPSI/houwanwanglitung"
exp="alltreatments"
EAPSIsamples="Wt1-3a Wt1-3b Wt1-3c Wt1-6a Wt1-6b Wt1-6c Wt2-3a Wt2-3b Wt2-3c Wt2-6a Wt2-6b Wt2-6c Hw1-3a Hw1-3b Hw1-3c Hw1-6a Hw1-6b Hw1-6c Hw2-3a Hw2-3b Hw2-3c Hw2-6b Hw2-6c"

echo "These are the .bam files to be quantified using featureCounts"
echo $EAPSIsamples
${mcs}/programs/subread-1.6.0-Linux-x86_64/bin/featureCounts -t gene \
-g ID \
-a ${mcs}/sequences/genomes/coral/pocillopora/pdam_genome.gff \
-o ${coldir}/${exp}/STARcounts_Pdam/${exp}_Pdam.counts \
${coldir}/${exp}/STARalign_Pdam/*Aligned.out.bam
