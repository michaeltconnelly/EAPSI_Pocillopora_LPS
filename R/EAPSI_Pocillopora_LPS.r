#EAPSI_Pocillopora_LPS.r
#author: "Mike Connelly"
#date: "12/03/2019"

library("tidyverse")
library("DESeq2")
library("ggpubr")
library("apeglm")

#Import sample data
stable_samples <- read.table("./data/EAPSIsamples_stable.txt", header = TRUE)
#Import counts data
countdata <- read.delim("LPS_Pdam.counts", row.names = 1, skip = 1)

