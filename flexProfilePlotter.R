knitr::opts_chunk$set(echo = TRUE)
library(reshape2)
library(ggplot2)
library(dplyr)

H3K27ac_unt_norm	<-	1
H3K27ac_vitc_norm	<-	0.9317231293
H3K27me3_unt_norm	<-	1
H3K27me3_vitc_norm	<-	1.051885339
H3K36me3_unt_norm	<-	1
H3K36me3_vitc_norm	<-	1.071834946
H3K4me1_unt_norm	<-	1
H3K4me1_vitc_norm	<-	1.103859432
H3K4me3_unt_norm	<-	1
H3K4me3_vitc_norm	<-	1.038804423
H3K9me3_unt_norm	<-	1
H3K9me3_vitc_norm	<-	1.044772184

flanksize <- 2500
binsize <- 50

allpro <- list.files(path="/Users/hirstlab/Desktop/mingay/default_temp", pattern=".profile", recursive=F, full.names = T)
allDat <- lapply(allpro, read.table, fill=T)

#Use gsub to isolate the library identifier (ex. H3K9me3_unt, H3K4me3_vitc, etc.) from the file name (allpro)

lib <- gsub(";", "_", gsub("\\..*", "", gsub(".*/", "", allpro)))
lib

#Use gsub to isolate the target mark (ex. H3K9me3, H3K4me3, etc.) from the file name (allpro)

mark <- gsub("_.*", "", lib)
mark


#Use gsub to isolate the treatment (unt or vitc) from the file name (allpro)

treatment <- gsub(".*_", "", lib)
treatment

#Use gsub to isolate the region being profiled (ex. cpg_islands) from the file name (allpro)

region <- gsub(".*\\.", "", gsub("_.*", "", gsub(".*/", "", allpro)))
region

#Normalizations values can be created to adjust signal from different libraries (ex. H3K9me3_unt, H3K4me3_vitc) by creating an object with all the normalization values for each library named: "{library}_norm" (ex. H3K4me3_vitc_norm)

norm_values <- do.call(c,lapply(as.list(paste0(lib, "_norm")),get))

all_profiles=NULL

for (i in 1:length(allpro)) {
  sample_temp <- data.frame(colMeans(allDat[[i]][,1:100]*norm_values[i]))
  colnames(sample_temp) <- "value"
  sample_temp$bin <- seq(-flanksize,flanksize-binsize,binsize)
  sample_temp$mark <- paste0(mark[i])
  sample_temp$treatment <- as.factor(paste0(treatment[i]))
  sample_temp$region <- as.factor(region[i])
  all_profiles <- rbind(all_profiles, sample_temp)
  rm(sample_temp)
}

ggplot(all_profiles, aes(bin, value, colour=treatment))+geom_line()+facet_wrap(~region)+
xlab("position relative to region centre")+
  ylab("average normalized signal")+
  theme_bw()+
  scale_colour_manual(values=c("springgreen4", "dodgerblue3", "black", "darkred"), name="Treatment")




