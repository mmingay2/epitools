# epitools

###A suite of tools that I developed to analyze high-throughput epigenomics data.

#### regionRandomizer

This tool compares one set of regions (**ROIs**) to another set of features/regions (**Features**).

I use [shuffleBed](http://bedtools.readthedocs.io/en/latest/) to create 33 randomized region sets from each real **ROIs** set while maintaining the same cumulative size and chromosomal distribution.

Then the association between each set of **ROIs** and each set of **Features** is compared to the average overlap between its 33 randomized counterparts and the same **Features** to provide a real vs. expected relationship between two sets of genomic coordinates.


