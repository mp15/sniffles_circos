# sniffles_circos

A way to make a CIRCOS plot of Sniffles BED files

How to run:
```
$ gunzip -k OESO_117_4.3.0_stereo_1.2.pass.map_sort.remap.sniffles_trf.vcf.gz
$ SURVIVOR/Debug/SURVIVOR vcftobed OESO_117_4.3.0_stereo_1.2.pass.map_sort.remap.sniffles_trf.vcf -1 -1 OESO_117_4.3.0_stereo_1.2.pass.map_sort.remap.sniffles_trf.bed
$ Rscript --vanilla sniffles_circos.R OESO_117_4.3.0_stereo_1.2.pass.map_sort.remap.sniffles_trf.bed OESO_117_4.3.0_stereo_1.2.pass.map_sort.remap.sniffles_trf.pdf "OESO_117 ONT"
```
