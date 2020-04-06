#!/usr/bin/env python
#purpose: Apply PICRUSt2 pipeline
#conda activate picrust2

picrust2_pipeline.py \
--study_fasta /Users/mikeconnelly/computing/projects/EAPSI_Pocillopora_LPS/outputs/qiime2/sequences.fasta \
--input /Users/mikeconnelly/computing/projects/EAPSI_Pocillopora_LPS/outputs/qiime2/export_silva/feature-table.biom \
--output picrust2_out_pipeline \
--verbose
