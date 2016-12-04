rm(list=ls())
dir <- "/github/HMP_data/"

otu_count = read.table(paste0(dir, "hmp1.v13.hq.otu.counts"), header=T, sep="\t")

otu_lookup = read.table(paste0(dir, "hmp1.v13.hq.otu.lookup"), header=F, sep=";", skip=1, fill=T)
otu_lookup[,1] <- 1:length(otu_lookup[,1])

for (x in 2:7) {
	otu_lookup[,x] <- gsub("\\(.*" , "", otu_lookup[,x])
}


meta = read.table(paste0(dir, "metadata.txt"), header=F, sep="\t", fill=T)

collect_id <- NULL
for (line in 1:nrow(otu_count)) {
	collect_id<- c(collect_id,strsplit(rownames(otu_count), "[.]")[[line]][1])
}

length(collect_id)
length(which(duplicated(collect_id) == T))

makeFiles <- function(spot) {
	t1<- otu_count[which(collect_id %in% unique(meta[which(meta[,1] == spot),2])== T),]
	t1<- t1[,-27656]
	calc<- round((colSums(t1, na.rm=T)/sum(colSums(t1, na.rm=T)))*100, 3)
	
	t2<- cbind(otu_lookup,calc)
	t2 <- t2[,c(-1,-8)]
	colnames(t2) <- c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Count")
	t2$Phylum<- factor(t2$Phylum, levels=c("Actinobacteria","Firmicutes","Proteobacteria","Bacteroidetes","TM7","Fusobacteria","Deinococcus-Thermus","Tenericutes","Cyanobacteria","SR1","unclassified","Spirochaetes","Verrucomicrobia","Lentisphaerae","Synergistetes","Acidobacteria","Planctomycetes","Nitrospira","BRC1","OD1","Chloroflexi","Gemmatimonadetes","OP10","","Thermotogae","OP11"))
	t2<- t2[order(t2$Phylum, t2$Class, t2$Genus),]
	t2$Phylum <- as.character(t2$Phylum)
	
	write.csv(t2, paste0(dir, spot, ".csv"), row.names=F)
}

for (i in unique(meta[,1])) {
	print(as.character(i))
	makeFiles(as.character(i))
}







