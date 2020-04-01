#!/bin/bash
#purpose: Classify ASVs using qiime2 feature-classifier trained for 16S V4 region
#conda activate qiime2-2020.2

prodir="/Users/mikeconnelly/computing/projects/EAPSI_Pocillopora_LPS"
exp="LPS"
EAPSIsamples="Wt1-3a Wt1-3b Wt1-3c Wt1-6a Wt1-6b Wt1-6c Wt2-3a Wt2-3b Wt2-3c Wt2-6a Wt2-6b Wt2-6c Hw1-3a Hw1-3b Hw1-3c Hw1-6a Hw1-6b Hw1-6c Hw2-3a Hw2-3b Hw2-3c Hw2-6a Hw2-6b Hw2-6c"
echo "QIIME2 classification process started"

### Classify representative sequences using a Naive Bayesian classifier trained using the 99% similarity Silva 132 reference sequences
### Remove all mitochondria and chloroplast sequences from classified representative sequences
### Remove all mitochondria and chloroplast sequences from classified feature table
### Create phylogenetic tree
qiime feature-classifier classify-sklearn \
  --i-classifier ${prodir}/data/classifiers/silva-132-99-515-806-nb-classifier.qza \
  --i-reads ${prodir}/outputs/qiime2/qza/all_rep-seqs.qza \
  --o-classification ${prodir}/outputs/qiime2/qza/all_classification_silva.qza

qiime metadata tabulate \
  --m-input-file ${prodir}/outputs/qiime2/qza/all_classification_silva.qza \
  --o-visualization ${prodir}/outputs/qiime2/qzv/all_classification_silva.qzv

qiime taxa filter-seqs \
  --i-sequences ${prodir}/outputs/qiime2/qza/all_rep-seqs.qza \
  --i-taxonomy ${prodir}/outputs/qiime2/qza/all_classification_silva.qza \
  --p-exclude mitochondria,chloroplast \
  --o-filtered-sequences ${prodir}/outputs/qiime2/qza/all_silva_rep-seqs-no-mtcp.qza
qiime feature-table tabulate-seqs \
  --i-data ${prodir}/outputs/qiime2/qza/all_silva_rep-seqs-no-mtcp.qza \
  --o-visualization ${prodir}/outputs/qiime2/qzv/all_silva_rep-seqs-no-mtcp_rep-seqs.qzv

qiime taxa filter-table \
  --i-table ${prodir}/outputs/qiime2/qza/all_table.qza \
  --i-taxonomy ${prodir}/outputs/qiime2/qza/all_classification_silva.qza \
  --p-exclude mitochondria,chloroplast \
  --o-filtered-table ${prodir}/outputs/qiime2/qza/all_silva_table-no-mtcp.qza
qiime feature-table summarize \
  --i-table ${prodir}/outputs/qiime2/qza/all_silva_table-no-mtcp.qza \
  --o-visualization ${prodir}/outputs/qiime2/qzv/all_silva_table-no-mtcp.qzv \

qiime phylogeny align-to-tree-mafft-fasttree \
--i-sequences ${prodir}/outputs/qiime2/qza/all_silva_rep-seqs-no-mtcp.qza \
--o-alignment ${prodir}/outputs/qiime2/qza/all_silva_aligned-rep-seqs-no-mtcp.qza \
--o-masked-alignment ${prodir}/outputs/qiime2/qza/all_silva_masked-aligned-rep-seqs-no-mtcp.qza \
--o-tree ${prodir}/outputs/qiime2/qza/all_silva_unrooted-tree.qza \
--o-rooted-tree ${prodir}/outputs/qiime2/qza/all_silva_rooted-tree.qza

bash ${prodir}/bash/qiime2/all_diversity_silva_qiime2.sh
