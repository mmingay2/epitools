# epitools

> A suite of tools that I developed to analyze high-throughput epigenomics data.

## flexProfiler.sh

For a folder full of WIG files and a folder full of BED files this tool will generate a matrix containing the average signal in 50bp bins across a 2.5kb window flanking the centre of the regions in a BED file.

`sh flexProfiler.sh -h`

Options:    
* -u `<your alias>` 
* -o `<output directory name (not full path)>` 
* -wp `<full path to wigs>` 
* -bp `<full path to beds>`  
* -f  `<flank size; default=1500 centre of region +/- {-f}>`
* `-bin <bin size default=50>`
* `-suff <suffix for wig files to bed removed in name {default=.q5.F1028.PET.wig.gz}>`
* `-g <4 character genome identifier (ex. mm10,hg19 etc.); {default=mm10}>`


Note: This tool requires JRE 1.8 or greater and a custom java calculator (available upon request).

---

## regionRandomizer.sh

This tool compares one set of regions (**ROIs**) to another set of features/regions (**Features**).

I use [shuffleBed](http://bedtools.readthedocs.io/en/latest/) to create 33 randomized region sets from each real **ROIs** set while maintaining the same cumulative size and chromosomal distribution.

Then the association between each set of **ROIs** and each set of **Features** is compared to the average overlap between its 33 randomized counterparts and the same **Features** to provide a real vs. expected relationship between two sets of genomic coordinates.

---

## toBamAligner.sh

This tool was created to align fastq files to a genome in the fasta format using the [Burrows-Wheeler Aligner](http://bio-bwa.sourceforge.net/).

This tool:

1. Aligns paired end fastq files from Illumina sequencing platforms to BAM format using [SAMtools](http://samtools.sourceforge.net/)
2. Marks duplicate reads in the bam file using [Picard](https://broadinstitute.github.io/picard/command-line-overview.html)
3. Generates common library QC metrics (*.flagstat)

---

## regionCharacterizer.sh

This tool takes a folder of BED files (*.bed) and CpG coordinates for your genome and provides the following metrics:

* # of regions
* genomic occupancy (kilobases)
* mean size
* total # of CpGs
* mean # of CpGs
* mean CpG density

---

## regionDistributer.sh

This tool calculates the proportion of regions within a BED file that exist within different genomic features (ex. Introns, Promoters). It is useful for making pie charts or stacked bar plots as the values for a given region set will add up to 1. 

---

![vitC](https://upload.wikimedia.org/wikipedia/commons/b/b1/Ascorbic_acid_H-bonding.svg)



