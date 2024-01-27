#!/usr/bin/env Rscript
library(circlize)

args <- commandArgs(trailingOnly = TRUE)
in_bed <- args[1]
out_pdf <- args[2]
sample_name <- args[3]

pdf(out_pdf)
bedpe_raw <- read.table(in_bed,
    col.names=c("chr1", "start1", "end1", "chr2", "start2", "end2", "name", "score", "strand1", "strand2", "type", "chrx", "startx", "chry", "starty"),
    colClasses=c("factor", "integer", "integer", "factor", "integer", "integer", "character",NA,"factor", "factor", "factor", "factor", "integer", "factor", "integer"),
    sep="\t")
#bedpe_raw <- read.table(gzfile("~/dev/sv_cluster/data/2126/WTSI-OESO_117_a_DNA/WTSI-OESO_117_a_DNA.brass.annot.bedpe.gz"), header = F, sep = "\t", stringsAsFactors = F)
#names(bedpe_raw) <- c("chr1", "start1", "end1", "chr2", "start2", "end2", "name", "score", "strand1", "strand2", "sample", "type")
#Filter down to canonical chromosomes and TRA + INV
bedpe <- bedpe_raw[ bedpe_raw$chr1 %in% c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10", "chr11", "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18", "chr19", "chr20", "chr21", "chr22", "chrX", "chrY") &
    bedpe_raw$chr2 %in% c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10", "chr11", "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18", "chr19", "chr20", "chr21", "chr22", "chrX", "chrY") &
    bedpe_raw$type %in% c("TRA", "INV"),]
#bedpe <- bedpe_raw[ bedpe_raw$chr1 %in% c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10", "chr11", "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18", "chr19", "chr20", "chr21", "chr22") &
#    bedpe_raw$chr2 %in% c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10", "chr11", "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18", "chr19", "chr20", "chr21", "chr22") &
#    bedpe_raw$type %in% c("translocation", "inversion"),]
circos.initializeWithIdeogram(species = "hg38")
circos.genomicLink(bedpe[,c("chr1", "start1", "end1", "name", "score", "strand1")],
                   bedpe[,c("chr2", "start2", "end2", "name", "score", "strand2")],
                   col = rand_color(nrow(bedpe), transparency = 0.5),
                   border = NA)
text(0, 0, sample_name, cex = 1)
dev.off()
