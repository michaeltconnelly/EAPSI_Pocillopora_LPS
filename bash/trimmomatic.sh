#!/bin/bash
#./bash/trimmomatic.sh
#purpose: wrapper script to submit jobs for trimming poor-quality bases and adapter sequences from raw RNAseq reads using Trimmomatic on Pegasus bigmem queue
#To start this job from the EAPSI_Pocillopora_LPS directory, use:
#bsub -P transcriptomics < /scratch/projects/transcriptomics/mikeconnelly/projects/EAPSI_Pocillopora_LPS/bash/trimmomatic.sh

#BSUB -J trimmomatic_wrapper
#BSUB -q bigmem
#BSUB -P transcriptomics
#BSUB -o trimwrap%J.out
#BSUB -e trimwrap%J.err
#BSUB -n 8
#BSUB -u mconnelly@rsmas.miami.edu
#BSUB -N

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
prodir="/scratch/projects/transcriptomics/mikeconnelly/projects/EAPSI_Pocillopora_LPS"
exp="LPS"
EAPSIsamples="Wt1-3a Wt1-3b Wt1-3c Wt1-6a Wt1-6b Wt1-6c Wt2-3a Wt2-3b Wt2-3c Wt2-6a Wt2-6b Wt2-6c Hw1-3a Hw1-3b Hw1-3c Hw1-6a Hw1-6b Hw1-6c Hw2-3a Hw2-3b Hw2-3c Hw2-6b Hw2-6c"

#lets me know which files are being processed
echo "These are the samples to be processed:"
echo $EAPSIsamples

#loop to automate generation of scripts to direct sequence file trimming
for EAPSIsample in $EAPSIsamples
do \
echo "$EAPSIsample"

#   input BSUB commands
echo '#!/bin/bash' > "${prodir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job
echo '#BSUB -q general' >> "${prodir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job
echo '#BSUB -J '"${EAPSIsample}"_trimmomatic'' >> "${prodir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job
echo '#BSUB -o '"${prodir}"/"${exp}"/logfiles/"$EAPSIsample"trim%J.out'' >> "${prodir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job
echo '#BSUB -e '"${prodir}"/"${exp}"/errorfiles/"$EAPSIsample"trim%J.err'' >> "${prodir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job

#   input command to load modules for trimming
echo 'module load java/1.8.0_60' >> "${prodir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job
echo 'module load trimmomatic/0.36' >> "${prodir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job

#   input command to unzip raw reads before trimming
echo 'echo 'Unzipping "${EAPSIsample}"'' >> "${prodir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job
echo 'gunzip '"${prodir}"/"${exp}"/zippedreads/"${EAPSIsample}".txt.gz >> "${prodir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job

#   input command to trim raw reads
echo 'echo 'Trimming "${EAPSIsample}"'' >> "${prodir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job
echo '/share/opt/java/jdk1.8.0_60/bin/java -jar /share/apps/trimmomatic/0.36/trimmomatic-0.36.jar \
SE \
-phred33 \
-trimlog '"${prodir}"/"${exp}"/logfiles/"${EAPSIsample}"_trim.log \
"${prodir}"/"${exp}"/zippedreads/"${EAPSIsample}".txt \
"${prodir}"/"${exp}"/trimmomaticreads/"${EAPSIsample}"_trimmed.fastq.gz \
ILLUMINACLIP:"${mcs}"/programs/Trimmomatic-0.36/adapters/TruSeq3-SE.fa:2:30:10 \
LEADING:3 \
TRAILING:3 \
SLIDINGWINDOW:4:15 \
MINLEN:36 >> "${prodir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job
echo 'echo '"$EAPSIsample" trimmed''  >> "${prodir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job

#   input command to zip raw reads after trimming
echo 'gzip '"${prodir}"/"${exp}"/zippedreads/"${EAPSIsample}".txt  >> "${prodir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job

#   submit generated trimming script to job queue
bsub < "${prodir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job
done
