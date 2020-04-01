#!/bin/bash
#purpose: import demultiplexed 16S sequence reads, summarize read depth and quality scores
#conda activate qiime2-2020.2

prodir="/Users/mikeconnelly/computing/projects/EAPSI_Pocillopora_LPS"
exp="LPS"
EAPSIsamples="Wt1-3a Wt1-3b Wt1-3c Wt1-6a Wt1-6b Wt1-6c Wt2-3a Wt2-3b Wt2-3c Wt2-6a Wt2-6b Wt2-6c Hw1-3a Hw1-3b Hw1-3c Hw1-6a Hw1-6b Hw1-6c Hw2-3a Hw2-3b Hw2-3c Hw2-6a Hw2-6b Hw2-6c"
echo "Import and QC summarize process started"

### Import demultiplexed 16S sequence reads into QIIME2 environment
qiime tools import \
--input-path ${prodir}/data/qiime2_manifest.tsv \
--input-format PairedEndFastqManifestPhred33V2 \
--output-path ${prodir}/outputs/qiime2/qza/all.qza \
--type 'SampleData[PairedEndSequencesWithQuality]'

### Summarize read depth and quality scores
qiime demux summarize \
--i-data ${prodir}/outputs/qiime2/qza/all.qza \
--o-visualization ${prodir}/outputs/qiime2/qzv/all.qzv

bash ${prodir}/bash/qiime2/all_dada2_qiime2.sh
