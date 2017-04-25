regions=/Users/Mingay/Desktop/epigenomics/manuscript/dev/test_regions/
dirt=/Users/Mingay/Desktop/epigenomics/manuscript/dev/test_ft/
temp=/Users/Mingay/Desktop/epigenomics/manuscript/dev/temp/
wout=/Users/Mingay/Desktop/epigenomics/manuscript/dev/out/
genome=/Users/Mingay/Desktop/epigenomics/mm10.chrom.sizes

mkdir -p "$wout"
mkdir -p "$temp"

cd $regions

rm $wout/*

#print column names

echo "sample_name" "num_samples" "bed_name" "n_bed" "n_intersect" "n_randomintersect" "intersect_prop" "n_window" "n_randomwindow" "window_prop" "jaccard" >> $wout/"results_temp.txt"

for sample in *.bed

do 
	samplename=${sample/.bed/}

	echo "$samplename"

	cd $dirt
	
	for tfbs in *.bed

	do
		tf=${tfbs/.bed/}

		echo "$tf"

#calculate average of 33 shuffled random overlaps

			for id in {1..33}

			do

			bedtools shuffle -chrom -i $regions/$sample -g $genome > $temp/"shuffle.bed"
			tempw=$(windowBed -u -a $temp/"shuffle.bed" -b $dirt/$tfbs | wc -l)
			tempi=$(intersectBed -u -a $temp/"shuffle.bed" -b $dirt/$tfbs | wc -l)
			tempn=$(closestBed -u -a $temp/"shuffle.bed" -b $dirt/$tfbs | wc -l)
			echo "$tempi" "tempw" | awk '{print $1"\t"$2}' >> $temp/"random.bed"
			rm $temp/"shuffle.bed"
			
			done

#calculate mean for randomized window and direct overlaps

		randomI=$(awk '{total +=$1}; END {print int(total)/33}' $temp/"random.bed")
		randomW=$(awk '{total +=$2}; END {print int(total)/33}' $temp/"random.bed")

#calculate number of region and number/proportion of overlaps
		
		ntf=$(wc -l < $dirt/$tfbs)
		nsample=$(wc -l < $regions/$sample)
		window=$(windowBed -u -a $regions/$sample -b $dirt/$tfbs | wc -l)
		inters=$(intersectBed -u -a $regions/$sample -b $dirt/$tfbs | wc -l)
		prop=$(echo $window $nsample | awk '{print int($1)/int($2)}')
		propI=$(echo $inters $nsample | awk '{print int($1)/int($2)}')

#calculate jaccard score 
		
		jaccard=$(bedtools jaccard -a $regions/$sample -b $dirt/$tfbs  | awk -F"\t" ' NR !=1 {print $3}')

#print summary
		echo "$samplename"
		echo "$tf"
		echo "results"
		echo "number of samples " "$nsample"
		echo "number of FT" "$ntf"
		echo "INTERSECT analysis"
		echo "n shuffled intersect" "$randomI"
		echo "number of real intersects" "$inters"
		propI=$(echo $inters $nsample | awk '{print int($1)/int($2)}')
		echo "proportion of overlaps" "$propI"
		echo "WINDOW analysis"
		echo "n shuffled window overlaps" "$randomW"
		echo "number of real window overlaps" "$window"
		prop=$(echo $window $nsample | awk '{print int($1)/int($2)}')
		echo "proportion of window overlaps" "$prop"
		echo "jaccard" "$jaccard"
		
#write results to file
		echo $samplename "$nsample" "$tf" "$ntf" "$inters" "$randomI" "$propI" "$window" "$randomW" "$prop" "$jaccard" >> $wout/"results_temp.txt"

rm $temp/"random.bed"

		done

done


awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11}' $wout/"results_temp.txt" > $wout/"results.txt"
