# select repeat from RepeatMasker out put file. For example, SINE_tRNA-Core-L2
awk -v OFS="\t" '$11=="SINE/tRNA-Core-L2"{print $5,$6-1,$7}' RMSK.fa.out >SINE_tRNA-Core-L2.bed
echo "SINE_tRNA-Core-L2.bed" >> TE.list

# generate a bed file of 5Kb-windows
bedtools makewindows -g size.genome.txt -w 5000 -s 2500 >seahorse.win5k.bed

# Calculate selected repeat percentage in each window in genome
while read p
do
bedtools intersect -a $p -b seahorse.win5k.bed -wo | sed -e 's/Chr/LG/g'| sed -e 's/_RaGOO//g'|grep -v "Chr0|tig" > ${p/.bed/}.txt
Rscript TE_guppy.R ${p/.bed/}.txt
done < TE.list
