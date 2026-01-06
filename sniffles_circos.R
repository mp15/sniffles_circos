#!/usr/bin/env Rscript
library(circlize)

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 3) {
    stop("We require at least 3 arguments")
}
in_bed <- args[1]
out_pdf <- args[2]
sample_name <- args[3]
if (length(args)>3) {
    caller <- args[4]
} else {
    caller <- "sniffles"
}

if (caller  == "sniffles")
{
    print("Sniffles mode")
    # Read and label BEDPE
    bedpe_raw <- read.table(in_bed,
        col.names=c("chr1", "start1", "end1", "chr2", "start2", "end2", "name", "score", "strand1", "strand2", "type", "chrx", "startx", "chry", "starty"),
        colClasses=c("factor", "integer", "integer", "factor", "integer", "integer", "character",NA,"factor", "factor", "factor", "factor", "integer", "factor", "integer"),
        sep="\t")
    # Filter down to canonical chromosomes and TRA + INV
    bedpe <- bedpe_raw[ bedpe_raw$chr1 %in% c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10", "chr11", "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18", "chr19", "chr20", "chr21", "chr22", "chrX", "chrY") &
        bedpe_raw$chr2 %in% c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10", "chr11", "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18", "chr19", "chr20", "chr21", "chr22", "chrX", "chrY") &
        bedpe_raw$type %in% c("TRA", "INV"),]
} else if ( caller == "brass") {
    print("brass mode")
    # Read and label BEDPE
    bedpe_raw <- read.table(gzfile(in_bed), header = F, sep = "\t", stringsAsFactors = F)
    names(bedpe_raw) <- c("chr1", "start1", "end1", "chr2", "start2", "end2", "name", "score", "strand1", "strand2", "sample", "type")
    # Filter down to canonical chromosomes and TRA + INV
    bedpe <- bedpe_raw[ bedpe_raw$chr1 %in% c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10", "chr11", "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18", "chr19", "chr20", "chr21", "chr22") &
        bedpe_raw$chr2 %in% c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10", "chr11", "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18", "chr19", "chr20", "chr21", "chr22") &
        bedpe_raw$type %in% c("translocation", "inversion"),]
} else if (caller  == "manta") {
    print("Manta mode")
    # Read and label BEDPE
    bedpe_raw <- read.table(in_bed,
        col.names=c("chr1", "start1", "end1", "chr2", "start2", "end2", "name", "score", "strand1", "strand2", "type", "filter", "info", "format", "sampledata"),
        colClasses=c("factor", "integer", "integer", "factor", "integer", "integer", "character",NA,"factor", "factor", "factor", "character", "character", "character", "character"),
        sep="\t")
    # Filter down to canonical chromosomes and TRA + INV
    bedpe <- bedpe_raw[ bedpe_raw$chr1 %in% c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10", "chr11", "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18", "chr19", "chr20", "chr21", "chr22", "chrX", "chrY") &
        bedpe_raw$chr2 %in% c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10", "chr11", "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18", "chr19", "chr20", "chr21", "chr22", "chrX", "chrY") &
        bedpe_raw$type %in% c("BND") &
        bedpe_raw$filter == "PASS",]
} else { stop("Unknown SV caller specified")}

# Draw to PDF rather than screen
pdf(out_pdf)
# Draw the ideogram
circos.initializeWithIdeogram(species = "hg38")
# Add SV track
circos.genomicLink(bedpe[,c("chr1", "start1", "end1", "name", "score", "strand1")],
                   bedpe[,c("chr2", "start2", "end2", "name", "score", "strand2")],
                   col = rand_color(nrow(bedpe), transparency = 0.5),
                   border = NA)
# Put sample name in the middle of the plot
text(0, 0, sample_name, cex = 1)
# Render complete
dev.off()
