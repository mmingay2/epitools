# epitools

1===0
 0===1
  1=0
   0
  0=1
 0===1
 1===0
  0=0
   1
  0=1
 1===0

> A suite of tools that I developed to analyze high-throughput epigenomics data.

## flexProfiler.sh

For a folder full of WIG files and a folder full of BED files this tool will generate a matrix containing the average signal in 50bp bins across a 1.5kb window (defaults) flanking the centre of each region in a BED file.

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

## flexProfilePlotter.R

This is an R script that is meant to process, normalize and visualize the files outputted by flexProfiler.sh (above). It strips information about library type, treatment group, position and region of interest from each `*.profile` file in a directory. For each file the program normalizes signal values and calulates the average signal in each X bp in Y kb flanking the centre of each set of regions. The resulting dataframe can quickly and easily be visualized with [ggplot2](http://ggplot2.org/) in R.

---

## regionRandomizer.sh

This tool compares one set of regions (**ROIs**) to another set of features/regions (**Features**).

It leverages [shuffleBed](http://bedtools.readthedocs.io/en/latest/) to create 33 randomized region sets from each real **ROIs** set, maintaining the same cumulative genomic occupancy and chromosomal distribution.

Then the actual association between each set of **ROIs** and each set of **Features** is compared to the average (expected) overlap between its 33 randomized counterparts and the **Features** to provide both a real vs. expected relationship between two sets of genomic coordinates.

---

## toBamAligner.sh

This tool was created to align fastq files to a genome (fasta) using the [Burrows-Wheeler Aligner](http://bio-bwa.sourceforge.net/) algorithm.

This tool:

1. Aligns paired-end fastq files from Illumina sequencing platforms to BAM format using [SAMtools](http://samtools.sourceforge.net/).
2. Marks duplicate reads in the bam file using [Picard](https://broadinstitute.github.io/picard/command-line-overview.html).
3. Generates common library QC metrics (*.flagstat).

---

## regionCharacterizer.sh

This tool takes a folder of BED files (*.bed) and CpG coordinates for your genome and provides the following metrics:

* \# of regions
* genomic occupancy (kilobases)
* mean size
* total \# of CpGs
* mean \# of CpGs
* mean CpG density

---

## regionDistributer.sh

This tool calculates the proportion of regions within a BED file that exist within different genomic features (ex. Introns, Promoters). It is useful for making pie charts or stacked bar plots as the output values will sum to 1. 

---

## flexCoverageCalculator.sh

This program is a simple `for` loop that iterates through a folder of [bigwig](https://genome.ucsc.edu/goldenpath/help/bigWig.html) files and a folder of bed files to calculate the average signal in each region using the UCSC utility [bigWigAverageOverBed](http://hgdownload.soe.ucsc.edu/admin/exe/macOSX.x86_64/).

`bigWigAverageOverBed`

`bigWigAverageOverBed v2 - Compute average score of big wig over each bed, which may have introns.`

usage: `bigWigAverageOverBed in.bw in.bed out.tab`

The output columns are:
* `name - name field from bed, which should be unique`
* `size - size of bed (sum of exon sizes`
* `covered - \# bases within exons covered by bigWig`
* `sum - sum of values over all bases covered`
* `mean0 - average over bases with non-covered bases counting as zeroes`
* `mean - average over just covered bases`

`Options:`
* `-stats=stats.ra - Output a collection of overall statistics to stat.ra file`
* `-bedOut=out.bed - Make output bed that is echo of input bed but with mean column appended`
* `-sampleAroundCenter=N - Take sample at region N bases wide centered around bed item, rather than the usual sample in the bed item.`
* `-minMax - include two additional columns containing the min and max observed in the area.`

---

![vitC](https://upload.wikimedia.org/wikipedia/commons/b/b1/Ascorbic_acid_H-bonding.svg)



