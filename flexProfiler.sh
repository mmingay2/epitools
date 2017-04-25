#!/bin/sh

if [ "$1" == "-h" ] ; then
    echo -e "Run profile calculator for wig:
    Usage: `basename $0` <options> 
Options:    
==========
 -u <your user id> 
 -o <output dir name (not full path)> 
 -wp <full path to wigs> 
 -bp <full path to beds>  
 -f  <flank size; default=1500 centre of region +/- {-f}> 
 -bin <bin size default=50>
 -suff <suffix for wig files {default=.q5.F1028.PET.wig.gz}>
 -g <genome (ex. mm10,hg19 etc.); {default=mm10}>
==========

java -> /gsc/software/linux-x86_64/jre1.8.0_66/bin/java
lib -> /home/mbilenky/bin/Solexa_Java/RegionsProfileFromWigCalculator.jar"

    exit 0
fi

###define defaults
flanksize=2500
binsize=50
userid=unknown
expid=default_temp
dwig=/home/mmingay/epigenomics/manuscript/histone_chip/sept_libs/wig/few/
dbed=/projects/epigenomics/workspace/flexCalc/bed/
suffix=.q5.F1028.PET.wig.gz
genome=mm10

###define options

while [ $# -gt 0 ]
do
    case "$1" in
        -u) userid="$2"; shift;;
        -o) expid="$2"; shift;;
        -wp) dwig="$2"; shift;;
        -bp) dbed="$2"; shift;;
        -f) flanksize="$2"; shift;;
        -bin) binsize="$2"; shift;;
        -suff) suffix="$2"; shift;;
        -g ) genome="$2"; shift;;
    esac
    shift
done

##run function

jav=/gsc/software/linux-x86_64/jre1.8.0_66/bin/java
lloc=/home/mbilenky/bin/Solexa_Java/
dout=$(echo "dout=/projects/epigenomics/workspace/flexCalc/flexProf/out/"$userid/$expid/)
mkdir -p "$dout"
echo "outputting to:" $dout
dtemp=$(echo "/projects/epigenomics/workspace/flexCalc/flexProf/temp/"$userid/)
echo "using temp dir:" $dtemp
mkdir -p "$dtemp"
echo "using beds from:" $dbed
echo "using wigs from:" $dwig
#use $ to call on a variable defined above 

cd "$dbed"

for bedn in *.bed

do
        
        name=${bedn/.bed/}
        echo "$name"
        awk -v var="$flanksize" '{print $1"\t"int(($2+$3)/2)-var"\t"int(($2+$3)/2)+var}' $dbed$bedn > $dtemp$name"_flanktemp.bed"

        cd "$dwig"

        for wig in *.wig.gz

        do
                wign=${wig%$suffix}
                mark=$(echo $wign | awk -F'[_.]' '{print $1}')
                echo "mark:" $mark
                treatment=$(echo $wign | awk -F'[_.]' '{print $2}')
                echo "treatment:" $treatment

        #$jav -jar -Xmx80G $lloc/RegionsProfileFromWigCalculator.jar -w $dwig$wig -r $dtemp$name"_flanktemp.bed" -o $dout -s $genome -n $mark";"$treatment -t Y -bin $binsize
        $jav -jar -Xmx80G $lloc/RegionsProfileFromWigCalculator.jar -w $dwig$wig -r $dtemp$name"_flanktemp.bed" -o $dout -s $genome -n $mark";"$treatment -t Z -bin $binsize

        done

        rm $dtemp$name"_flanktemp.bed"
done
