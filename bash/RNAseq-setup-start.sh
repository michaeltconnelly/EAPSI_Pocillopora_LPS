#!/bin/bash
#./bash/RNAseq-setup-start.sh
#purpose: create directory structure, copy program binaries and reference sequences into Pegasus scratch space
#To start this job from the EAPSI_Pocillopora_LPS directory, use:
#bsub -P transcriptomics < ./bash/RNAseq-setup-start.sh

#BSUB -J RNAseq_setup
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -o setup%J.out
#BSUB -e setup%J.err
#BSUB -n 8
#BSUB -u mconnelly@rsmas.miami.edu
#BSUB -N

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
prodir="/scratch/projects/transcriptomics/mikeconnelly/projects/EAPSI_Pocillopora_LPS"
exp="LPS"
EAPSIsamples="Wt1-3a Wt1-3b Wt1-3c Wt1-6a Wt1-6b Wt1-6c Wt2-3a Wt2-3b Wt2-3c Wt2-6a Wt2-6b Wt2-6c Hw1-3a Hw1-3b Hw1-3c Hw1-6a Hw1-6b Hw1-6c Hw2-3a Hw2-3b Hw2-3c Hw2-6b Hw2-6c"

echo "Pipeline setup process started"

#copy reference sequences
#Pocillopora genome - .fasta, .gff, STAR index
cp -r ~/sequences/genomes/coral/pocillopora ${mcs}/sequences/genomes/coral/
#Symbiodinium C1 genome - .fasta, .gff, STAR index
cp -r ~/sequences/genomes/symbiodinium ${mcs}/sequences/genomes/
echo "Reference genome sequences copied to scratch"

#copy program binaries, change permissions, and load necessary modules
#execute FASTQC and Trimmomatic using Pegasus modules
module load java/1.8.0_60
module load trimmomatic/0.36
cp -r ~/programs/Trimmomatic-0.36 ${mcs}/programs
cp -r ~/programs/FastQC ${mcs}/programs
cp -r ~/programs/STAR-2.5.3a ${mcs}/programs
cp -r ~/programs/subread-1.6.0-Linux-x86_64 ${mcs}/programs
chmod 755 ${mcs}/programs/FastQC/fastqc
echo "Program files copied to scratch"

#make file structure for pipeline file input/output
mkdir ${prodir}/data
mkdir ${prodir}/data/zippedreads
mkdir ${prodir}/bash
mkdir ${prodir}/bash/jobs
mkdir ${prodir}/R
mkdir ${prodir}/Rmd
mkdir ${prodir}/outputs
mkdir ${prodir}/outputs/logfiles
mkdir ${prodir}/outputs/errorfiles
mkdir ${prodir}/outputs/fastqcs
mkdir ${prodir}/outputs/trimqcs
mkdir ${prodir}/outputs/trimmomaticreads
mkdir ${prodir}/outputs/STARalign_Pdam
mkdir ${prodir}/outputs/STARcounts_Pdam
mkdir ${prodir}/outputs/DESeq-results
mkdir ${prodir}/outputs/DESeq-results/figures
mkdir ${prodir}/outputs/DESeq-results/lists
mkdir ${prodir}/outputs/DESeq-results/REVIGO
mkdir ${prodir}/outputs/DESeq-results/tables
mkdir ${prodir}/outputs/DESeq-results/topGO
mkdir ${prodir}/outputs/phyloseq-results
mkdir ${prodir}/outputs/phyloseq-results/figures
echo "Filesystem and project directories created"

#copy EAPSI sequences
for EAPSIsample in $EAPSIsamples
do \
cp -r ~/sequences/EAPSI/zippedreads/${EAPSIsample}.txt.gz ${prodir}/data/zippedreads
done
echo "EAPSI sequences copied"

#Call first scripts in analysis pipeline
bsub -P transcriptomics < ${prodir}/bash/fastqc.sh
bsub -P transcriptomics < ${prodir}/bash/trimmomatic.sh
echo "RNAseq pipeline scripts successfully activated"
