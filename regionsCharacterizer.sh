#!/bin/sh

#regions characterizer

#Path to tab-separated bed files with 3 columns (chr, start, end)
dir=/Users/Mingay/Desktop/epigenomics/manuscript/bed_bin_may/histone_peaks/3col/

#Path to CpG locations within the genome to which your data is aligned 
cg=/Users/Mingay/Desktop/epigenomics/manuscript/bed_bin_may/mm10_ft/CG.bed

#path to output folder which will be created if it does not already exist 
out=/Users/Mingay/Desktop/epigenomics/manuscript/dev_out/

####


mkdir -p "$out"

cd $dir

rm $out"characterizer_test.txt"

touch $out"characterizer_temp.txt"

echo "name"	"n_regions" "total_kb_covered"	"mean_size"	"total_n_cpgs"	"mean_n_cpgs"	"mean_cpg_density" >> $out"characterizer_temp.txt"

for region in *.bed 

do

name=${region/.bed/}

echo $name
echo $region

nreg=$(wc -l < $dir$region)

echo "n regions" $nreg

#total Kb covered 
totalkb=$(awk '{print $3-$2}' $dir$region | awk '{total +=$1}; END {print int(total)}')

echo "total kb" $totalkb

#average size
meansize=$(echo $totalkb $nreg | awk '{print $1/$2}')

echo "mean size" $meansize

#total number of CpGs
totalcpg=$(intersectBed -c -a $dir$region -b $cg | awk '{total +=$4}; END {print int(total)}')

echo "total cpg" $totalcpg
#average number of CpG per region
meancpg=$(echo $totalcpg $nreg | awk '{print $1/$2}')

echo "mean cpg" $meancpg
#average CpG density
meanDens=$(echo $meancpg $meansize | awk '{print $1/$2}')

echo "mean cpg density" $meanDens

echo $name	"$nreg" "$totalkb"	"$meansize"	"$totalcpg"	"$meancpg"	"$meanDens" >> $out"characterizer_temp.txt"

awk -F '\t' '{print $1}' $dir$region | sort | uniq -c | sort -nr | awk -v var="$nreg" '{print $2"\t"$1"\t"$1/var}' > $out$name"_chr_dist.txt"

head -n 3 $out$name"_chr_dist.txt"

done

awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7}' $out"characterizer_temp.txt" > $out"characterizer_test.txt"

rm $out"characterizer_temp.txt"



