



dir=/projects/sbs_primary1/hs28/170317_700957F_0161_A_CAVU8ANXX/Data/current/BaseCalls/CAVU8ANXX_Raw_Fastqs/
genome=/projects/epigenomics/software/novoalign/mm10_build38_mouse.fasta.fai
#genome=/home/pubseq/genomes/Homo_sapiens/hg19a/bwa_ind/genome/GRCh37-lite.fa
bwa=/home/pubseq/BioSw/bwa/bwa-0.7.5a/bwa
samtools=/home/pubseq/BioSw/samtools/samtools-0.1.16/samtools
out=/projects/epigenomics2/users/mmingay/march27_alignments/

mkdir -p "$out"

for file in AAAGCA_S1 ACTTGA_S2 CGAGAA_S3 CGTACG_S4 CTGCTG_S5 GACGGA_S6 GCCAAT_S7 GCCGCG_S8

do
	echo "aligning fastqs"
	echo "lane8_"$file"_L008_R1_001.fastq.gz"
	echo "$name"

	$bwa mem -M -t 12 $genome $dir"lane8_"$file"_L008_R1_001.fastq.gz" $dir"lane8_"$file"_L008_R2_001.fastq.gz" > $out$file".sam"

	#Make bam from sam
	echo "make bam from sam"
	echo "$file"

	$samtools view -S -b $out$file".sam" > $out$file".bam"
	rm -rf $out/*.sa*

	#sort bam
	echo "sort bam"
	echo "$file"

	$samtools sort $out$file".bam" $out$file".sorted"

	#mark duplicates
	echo "mark duplicates"
	echo "$file"

	java -jar -Xmx10G /home/pubseq/BioSw/picard/picard-tools-1.52/MarkDuplicates.jar I=$out$file".sorted.bam" O=$out$file".sorted.dups_marked.bam" M=dups AS=true VALIDATION_STRINGENCY=LENIENT QUIET=true

	#run flagstat
	echo "run flagstat"
	echo "$file"

	$samtools flagstat $out/$name.sorted.dups_marked.bam > $out/$name.flagstat

done


