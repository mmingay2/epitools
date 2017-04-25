bwdir=/home/mmingay/vitamin_c/bigwigs/
util=/home/mbilenky/UCSCtools/bigWigAverageOverBed
out=/home/mmingay/epigenomics/coverages/
bedir=/projects/epigenomics/workspace/vitamin_c/bedbin/

mkdir -p "$out"

cd $bwdir

for bigwig in *.bw

do
	bwname=${bigwig/.bw/}

	cd $bedir

	for bed in *.bed 

	do

		bedname=${bed/.bed/}

		cat -n $bedir$bed | awk -v var=$bedname '{print $2"\t"$3"\t"$4"\t"var"_"$1}' > $out$"temp.bed"

		$util $bwdir$bigwig $out$"temp.bed" $out$bwname"_"$bedname".coverage"

		rm $out$"temp.bed"

	done

done
