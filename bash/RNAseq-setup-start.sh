#!/bin/bash
#./bash/RNAseq-setup-start.sh
#purpose: create directory structure, copy program binaries and reference sequences into Pegasus scratch space
#To start this job from the EAPSI_Pocillopora_LPS directory, use:
#bsub -P transcriptomics < /scratch/projects/transcriptomics/mikeconnelly/projects/EAPSI_Pocillopora_LPS/bash/RNAseq-setup-start.sh

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
coldir="/scratch/projects/transcriptomics/mikeconnelly/sequences/EAPSI/houwanwanglitung"
exp="LPS"
EAPSIsamples="Wt1-3a Wt1-3b Wt1-3c Wt1-6a Wt1-6b Wt1-6c Wt2-3a Wt2-3b Wt2-3c Wt2-6a Wt2-6b Wt2-6c Hw1-3a Hw1-3b Hw1-3c Hw1-6a Hw1-6b Hw1-6c Hw2-3a Hw2-3b Hw2-3c Hw2-6b Hw2-6c"

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
mkdir ${coldir}
mkdir ${coldir}/${exp}
mkdir ${coldir}/${exp}/scripts
mkdir ${coldir}/${exp}/logfiles
mkdir ${coldir}/${exp}/errorfiles
mkdir ${coldir}/${exp}/zippedreads
mkdir ${coldir}/${exp}/fastqcs
mkdir ${coldir}/${exp}/trimmomaticreads
mkdir ${coldir}/${exp}/trimqcs
#STAR
mkdir ${coldir}/${exp}/STARalign_Pdam
mkdir ${coldir}/${exp}/STARcounts_Pdam
mkdir ${coldir}/${exp}/STARalign_SymC1
mkdir ${coldir}/${exp}/STARcounts_SymC1
echo "Filesystem and project directories created"

#copy EAPSI sequences
for EAPSIsample in $EAPSIsamples
do \
cp -r ~/sequences/EAPSI/zippedreads/${EAPSIsample}.txt.gz ${coldir}/${exp}/zippedreads
done
echo "EAPSI sequences copied"

#Call first scripts in analysis pipeline
bsub -P transcriptomics < /scratch/projects/transcriptomics/mikeconnelly/scripts/EAPSI.HW-WT-master/fastqc.sh
bsub -P transcriptomics < /scratch/projects/transcriptomics/mikeconnelly/scripts/EAPSI.HW-WT-master/trimmomatic_EAPSI.sh
echo "RNAseq pipeline scripts successfully activated"

#bsub -P transcriptomics < /scratch/projects/transcriptomics/mikeconnelly/scripts/EAPSI.HW-WT-master/trimqc.sh
#bsub -P transcriptomics < /scratch/projects/transcriptomics/mikeconnelly/scripts/EAPSI.HW-WT-master/STARalign_Pdam.sh
#bsub -P transcriptomics < /scratch/projects/transcriptomics/mikeconnelly/scripts/EAPSI.HW-WT-master/STARalign_SymC1.sh
