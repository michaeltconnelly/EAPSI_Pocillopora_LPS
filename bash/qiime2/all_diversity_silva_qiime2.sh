#!/bin/bash
#purpose: Calculate core diversity metrics and generate rarefaction statistics on ASVs classified against SILVA database
#conda activate qiime2-2020.2

prodir="/Users/mikeconnelly/computing/projects/EAPSI_Pocillopora_LPS"
exp="LPS"
EAPSIsamples="Wt1-3a Wt1-3b Wt1-3c Wt1-6a Wt1-6b Wt1-6c Wt2-3a Wt2-3b Wt2-3c Wt2-6a Wt2-6b Wt2-6c Hw1-3a Hw1-3b Hw1-3c Hw1-6a Hw1-6b Hw1-6c Hw2-3a Hw2-3b Hw2-3c Hw2-6a Hw2-6b Hw2-6c"
echo "Core diversity analyses started for SILVA"

### Run core diversity metrics analysis on reads rareified to a depth of 2,600
qiime diversity core-metrics-phylogenetic \
--i-phylogeny ${prodir}/outputs/qiime2/qza/all_silva_rooted-tree.qza \
--i-table ${prodir}/outputs/qiime2/qza/all_silva_table-no-mtcp.qza \
--p-sampling-depth 2600 \
--m-metadata-file ${prodir}/data/qiime2_metadata.tsv \
--output-dir ${prodir}/outputs/qiime2/core-metrics-results_silva/

qiime diversity alpha-rarefaction \
  --i-table ${prodir}/outputs/qiime2/qza/all_silva_table-no-mtcp.qza \
  --i-phylogeny ${prodir}/outputs/qiime2/qza/all_silva_rooted-tree.qza \
  --p-max-depth 12000 \
  --m-metadata-file ${prodir}/data/qiime2_metadata.tsv \
  --o-visualization ${prodir}/outputs/qiime2/qzv/all_silva_alpha-rarefaction.qzv

### Create taxa barplot visualization
qiime taxa barplot \
  --i-table ${prodir}/outputs/qiime2/qza/all_silva_table-no-mtcp.qza \
  --i-taxonomy ${prodir}/outputs/qiime2/qza/all_classification_silva.qza \
  --m-metadata-file ${prodir}/data/qiime2_metadata.tsv \
  --o-visualization ${prodir}/outputs/qiime2/qzv/all_silva_barplot_no-mtcp.qzv \

  qiime feature-table summarize \
  --i-table ${prodir}/outputs/qiime2/core-metrics-results_silva/rarefied_table.qza \
  --o-visualization ${prodir}/outputs/qiime2/qzv/all_silva_rarefied_table.qzv

  ##move qza and qzv from diversity analyses to appropriate folders
  #mv ./core-metrics-results_silva/*.qza ${prodir}/outputs/qiime2/qza/
  #mv ./core-metrics-results_silva/*.qzv ${prodir}/outputs/qiime2/qzv/

bash ${prodir}/bash/qiime2/all_export_silva_qiime2.sh
