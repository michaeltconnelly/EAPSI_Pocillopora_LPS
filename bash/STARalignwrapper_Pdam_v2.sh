#!/bin/bash
#./bash/STARalignwrapper_Pdam_v2.sh
#purpose: align trimmed RNAseq reads against the Pocillopora damicornis genome using STAR on the Pegasus bigmem queue
#version 2: two-pass alignment for improved splice junction detection accuracy, downstream SNP calling and phylotranscriptomics, output non-aligning reads for Symbiodinaceae analysis
#To start this job from the EAPSI_Pocillopora_LPS directory, use:
#bsub -P transcriptomics < /scratch/projects/transcriptomics/mikeconnelly/projects/EAPSI_Pocillopora_LPS/bash/STARalignwrapper_Pdam_v2.sh

#BSUB -J starwrap_pdam
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -o STARwrap_pdam%J.out
#BSUB -e STARwrap_pdam%J.err
#BSUB -n 8
#BSUB -u m.connelly1@umiami.edu

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
coldir="/scratch/projects/transcriptomics/mikeconnelly/sequences/EAPSI/houwanwanglitung"
exp="alltreatments"
EAPSIsamples="Wt1-3a Wt1-3b Wt1-3c Wt1-6a Wt1-6b Wt1-6c Wt2-3a Wt2-3b Wt2-3c Wt2-6a Wt2-6b Wt2-6c Hw1-3a Hw1-3b Hw1-3c Hw1-6a Hw1-6b Hw1-6c Hw2-3a Hw2-3b Hw2-3c Hw2-6b Hw2-6c"

#lets me know which files are being processed
echo "These are the reads to be aligned to the Pocillopora reference genome: $EAPSIsamples"

#loop to automate generation of scripts to direct sequence file trimming
for EAPSIsample in $EAPSIsamples
do \
echo "Aligning ${EAPSIsample}"

#   input BSUB commands
echo '#!/bin/bash' > "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_staralign_pdam.job
echo '#BSUB -q bigmem' >> "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_staralign_pdam.job
echo '#BSUB -J '"${EAPSIsample}"_staralign_pdam'' >> "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_staralign_pdam.job
echo '#BSUB -o '"${coldir}"/"${exp}"/logfiles/"$EAPSIsample"staralign_pdam%J.out'' >> "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_staralign_pdam.job
echo '#BSUB -e '"${coldir}"/"${exp}"/errorfiles/"$EAPSIsample"staralign_pdam%J.err'' >> "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_staralign_pdam.job
echo '#BSUB -n 8' >> "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_staralign_pdam.job
echo '#BSUB -W 4:00' >> "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_staralign_pdam.job

#   input command to run STAR aligner
echo ${mcs}/programs/STAR-2.5.3a/bin/Linux_x86_64/STAR \
--runMode alignReads \
--quantMode TranscriptomeSAM \
--runThreadN 16 \
--readFilesIn ${coldir}/${exp}/trimmomaticreads/${EAPSIsample}_trimmed.fastq.gz \
--readFilesCommand gunzip -c \
--genomeDir ${mcs}/sequences/genomes/coral/pocillopora/STARindex \
--sjdbGTFfeatureExon exon \
--sjdbGTFtagExonParentTranscript Parent \
--sjdbGTFfile  ${mcs}/sequences/genomes/coral/pocillopora/pdam_genome.gff \
--twopassMode Basic \
--twopass1readsN -1 \
--outStd Log BAM_Unsorted BAM_Quant \
--outSAMtype BAM Unsorted \
--outReadsUnmapped Fastx \
--outFileNamePrefix ${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}_Pdam >> "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_staralign_pdam.job

#lets me know file is done
echo 'echo' "STAR alignment of $EAPSIsample complete"'' >> "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_staralign_pdam.job
echo "STAR alignment script of $EAPSIsample submitted"
#   submit generated trimming script to job queue
bsub < "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_staralign_pdam.job
done
