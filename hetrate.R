library(reshape2)
library(dplyr)
files = list.files(pattern="*.Ph.vcf")  #Load phenotype vcf file
snp<- do.call(rbind, lapply(files, function(x) read.table(x, header=FALSE, stringsAsFactors = FALSE,check.names = FALSE)))
snp<-mutate(snp, id = paste(V1, V2,sep = ':'))
snp[snp=="1|0"]="Heterozygous variant"
snp[snp=="0|1"]="Heterozygous variant"
snp[snp=="1|1"]="Homozygous variant"
snp[snp=="0|0"]="Homozygous reference"
snp<-snp[,-c(1:9)]
ml<-melt(snp,id="id")
colnames(ml)<-(c("SNP","Individual","Type"))       

ml$Sex<-c(rep("F",nrow(snp)*29),rep("M",nrow(snp)*30))
colnames(ml)<-c("SNP","ind","type","Sex")
library(plyr)
freq<-as.data.frame(ddply(ml, .(SNP,type,Sex), summarise, count=length(ind), .drop=FALSE))
freq2<-dcast(freq,SNP~type+Sex)
write.csv(freq2,file="hetcount.csv")    #get a csv file of counts of genotype in each sex



