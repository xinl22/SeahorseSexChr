library(dplyr)
library(intervals)
library(ggplot2)
SEQ<-read.csv("LG_seq.csv",header = T,stringsAsFactors = F)
seahorseLG_order<-SEQ$Seahorse
pipefishLG_order<-SEQ$pipefish

args<-commandArgs(T)
rep<-read.table(args[1], header=FALSE, stringsAsFactors = FALSE,check.names = FALSE)

# Calculate repeat length of each window
Sorted_repeats<-rep[
  with(rep, order(V1,V5, V2)),
  ]
Sorted_repeats<-Sorted_repeats[grep("LG", Sorted_repeats$V1), ]
chrOrder<-c(paste("LG",1:21,sep=""))
Sorted_repeats$V1<-factor(Sorted_repeats$V1, levels=chrOrder)
Sorted_repeats<-Sorted_repeats[order(Sorted_repeats$V1),]

Sorted_repeats$V3<-ifelse(Sorted_repeats$V3<=Sorted_repeats$V6, Sorted_repeats$V3,Sorted_repeats$V6)
Sorted_repeats$V2<-ifelse(Sorted_repeats$V2<=Sorted_repeats$V5,Sorted_repeats$V5+1, Sorted_repeats$V2)
Sorted_repeats<-mutate(Sorted_repeats, win = paste(V4, V5,V6,sep = '_'))

Sorted_repeats<-Sorted_repeats[,c(1,2,3,8)]
Sorted_repeats$V2<-as.numeric(Sorted_repeats$V2)
Sorted_repeats$V3<-as.numeric(Sorted_repeats$V3)
winlist<-unique(Sorted_repeats$win)
allchr<-list()
idf<-list()
for(i in 1:length(winlist)) {
  allchr[[i]]<-subset(Sorted_repeats,win==winlist[i])
  idf[[i]]<- Intervals(allchr[[i]][,2:3])
  idf[[i]]<-as.data.frame(interval_union(idf[[i]]))
}

for(i in 1:length(winlist)) {
  idf[[i]]$dist<-idf[[i]]$V2-idf[[i]]$V1
  idf[[i]]$win<-rep(winlist[i],nrow(idf[[i]]))
}
df <- do.call("rbind", idf)

TElen<-aggregate(dist ~ win, data = df, sum, .drop=FALSE)
splitrow<-as.data.frame(do.call(rbind, strsplit(TElen$win, '_')))
TElen<-cbind(TElen,splitrow)
colnames(TElen)<-c("win","dist","chr","winstart","winend")
TElen$winstart<-as.numeric(as.vector(TElen$winstart))
TElen$winend<-as.numeric(as.vector(TElen$winend))
TElen$winsize<-((TElen$winend)) - ((TElen$winstart))
TElen2<-arrange(TElen,chr,winstart)
TElen2$TE_percentage<-TElen2$dist/TElen2$winsize
TElen2$chr<-factor(TElen2$chr, levels=unique(seahorseLG_order))
TElen2<-TElen2[order(TElen2$chr),]
TE_pct<-TElen2[,c(3,4,5,7)]
options(scipen = 999)

write.table(TE_pct,file = paste(args[1],".bed",sep=""),quote = F,row.names = F,col.names = F, sep = '\t')

