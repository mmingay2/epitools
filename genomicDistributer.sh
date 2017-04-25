dirF=/home/mmingay/epigenomics/manuscript/bed_bin/pie/features/
dirR=/home/mmingay/epigenomics/manuscript/bed_bin/pie/regions/
out=/home/mmingay/epigenomics/manuscript/bed_bin/pie/results/

mkdir -p "$out"

cd $dirR

for region in *.bed

do

        name=${region/.bed/}

        cd $dirF

        echo "$name"

        nrow=$(wc -l < $dirR$region)

        intersectBed -u -a $dirR$region -b TSS_cgi.bed | wc -l | awk '{print $0"\t""promoter_cgi"}' > $out$name".txt"
        intersectBed -v -a $dirR$region -b TSS_cgi.bed | intersectBed -u -a stdin -b TSS_enhancers.bed | wc -l | awk '{print $0"\t""promoter_enhancer"}' >> $out$name".txt"
        intersectBed -v -a $dirR$region -b TSS_cgi.bed | intersectBed -v -a stdin -b TSS_enhancers.bed | intersectBed -u -a stdin -b promoters.bed | wc -l | awk '{print $0"\t""promoters"}' >> $out$name".txt"
        intersectBed -v -a $dirR$region -b TSS_cgi.bed | intersectBed -v -a stdin -b TSS_enhancers.bed | intersectBed -v -a stdin -b promoters.bed | intersectBed -u -a stdin -b cgi_genic.bed | wc -l | awk '{print $0"\t""cgi_intragenic"}' >> $out$name".txt"
        intersectBed -v -a $dirR$region -b TSS_cgi.bed | intersectBed -v -a stdin -b TSS_enhancers.bed | intersectBed -v -a stdin -b promoters.bed | intersectBed -v -a stdin -b cgi_genic.bed | intersectBed -u -a stdin -b cgi_intergenic.bed | wc -l | awk '{print $0"\t""cgi_intergenic"}' >> $out$name".txt"
        intersectBed -v -a $dirR$region -b TSS_cgi.bed | intersectBed -v -a stdin -b TSS_enhancers.bed | intersectBed -v -a stdin -b promoters.bed | intersectBed -v -a stdin -b cgi_genic.bed | intersectBed -v -a stdin -b cgi_intergenic.bed | intersectBed -u -a stdin -b enhancers_genic.bed | wc -l | awk '{print $0"\t""enhancers_intragenic"}' >> $out$name".txt"
        intersectBed -v -a $dirR$region -b TSS_cgi.bed | intersectBed -v -a stdin -b TSS_enhancers.bed | intersectBed -v -a stdin -b promoters.bed | intersectBed -v -a stdin -b cgi_genic.bed | intersectBed -v -a stdin -b cgi_intergenic.bed | intersectBed -v -a stdin -b enhancers_genic.bed | intersectBed -u -a stdin -b enhancers_intergenic.bed | wc -l | awk '{print $0"\t""enhancers_intergenic"}' >> $out$name".txt"
        intersectBed -v -a $dirR$region -b TSS_cgi.bed | intersectBed -v -a stdin -b TSS_enhancers.bed | intersectBed -v -a stdin -b promoters.bed | intersectBed -v -a stdin -b cgi_genic.bed | intersectBed -v -a stdin -b cgi_intergenic.bed | intersectBed -v -a stdin -b enhancers_genic.bed | intersectBed -v -a stdin -b enhancers_intergenic.bed | intersectBed -u -a stdin -b mm10_exons.bed | wc -l | awk '{print $0"\t""exons"}' >> $out$name".txt"
        intersectBed -v -a $dirR$region -b TSS_cgi.bed | intersectBed -v -a stdin -b TSS_enhancers.bed | intersectBed -v -a stdin -b promoters.bed | intersectBed -v -a stdin -b cgi_genic.bed | intersectBed -v -a stdin -b cgi_intergenic.bed | intersectBed -v -a stdin -b enhancers_genic.bed | intersectBed -v -a stdin -b enhancers_intergenic.bed | intersectBed -v -a stdin -b mm10_exons.bed | intersectBed -u -a stdin -b mm10_introns.bed | wc -l | awk '{print $0"\t""introns"}' >> $out$name".txt"
        intersectBed -v -a $dirR$region -b TSS_cgi.bed | intersectBed -v -a stdin -b TSS_enhancers.bed | intersectBed -v -a stdin -b promoters.bed | intersectBed -v -a stdin -b cgi_genic.bed | intersectBed -v -a stdin -b cgi_intergenic.bed | intersectBed -v -a stdin -b enhancers_genic.bed | intersectBed -v -a stdin -b enhancers_intergenic.bed | intersectBed -v -a stdin -b mm10_exons.bed | intersectBed -v -a stdin -b mm10_introns.bed | wc -l | awk '{print $0"\t""intergenic"}' >> $out$name".txt"

        awk -v var="$nrow" '{print $1"\t"$1/var"\t"$2}' $out$name".txt" > $out$name"_prop.txt"

done
