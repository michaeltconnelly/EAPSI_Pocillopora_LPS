#!/bin/bash
#purpose: Apply PICRUSt2 pipeline
#conda activate qiime2-2020.2
#qiime picrust2 full-pipeline --help

prodir="/Users/mikeconnelly/computing/projects/EAPSI_Pocillopora_LPS"
exp="LPS"
EAPSIsamples="Wt1-3a Wt1-3b Wt1-3c Wt1-6a Wt1-6b Wt1-6c Wt2-3a Wt2-3b Wt2-3c Wt2-6a Wt2-6b Wt2-6c Hw1-3a Hw1-3b Hw1-3c Hw1-6a Hw1-6b Hw1-6c Hw2-3a Hw2-3b Hw2-3c Hw2-6a Hw2-6b Hw2-6c"
echo "PICRUSt2 pipeline started"

#mkdir ${prodir}/outputs/qiime2/q2-picrust2_output
#mkdir ${prodir}/outputs/qiime2/q2-picrust2_output/pathabun_exported

qiime picrust2 full-pipeline \
   --i-table ${prodir}/outputs/qiime2/qza/all_silva_table-no-mtcp.qza \
   --i-seq ${prodir}/outputs/qiime2/qza/all_silva_rep-seqs-no-mtcp.qza \
   --output-dir ${prodir}/outputs/qiime2/q2-picrust2_output \
   --p-threads 8 \
   --p-hsp-method mp \
   --p-max-nsti 2 \
   --verbose

qiime feature-table summarize \
   --i-table ${prodir}/outputs/qiime2/q2-picrust2_output/pathway_abundance.qza \
   --o-visualization ${prodir}/outputs/qiime2/q2-picrust2_output/pathway_abundance.qzv

qiime diversity core-metrics \
   --i-table ${prodir}/outputs/qiime2/q2-picrust2_output/pathway_abundance.qza \
   --p-sampling-depth 2600 \
   --m-metadata-file ${prodir}/data/qiime2_metadata.tsv \
   --output-dir ${prodir}/outputs/qiime2/q2-picrust2_output/pathabun_core_metrics_out \
   --p-n-jobs 1

qiime tools export \
   --input-path ${prodir}/outputs/qiime2/q2-picrust2_output/pathway_abundance.qza \
   --output-path ${prodir}/outputs/qiime2/q2-picrust2_output/pathabun_exported

biom convert \
   -i ${prodir}/outputs/qiime2/q2-picrust2_output/pathabun_exported/feature-table.biom \
   -o ${prodir}/outputs/qiime2/q2-picrust2_output/pathabun_exported/feature-table.biom.tsv \
   --to-tsv
