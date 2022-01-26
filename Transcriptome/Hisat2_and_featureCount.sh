#!/bin/sh

#PBS -N hisat

#PBS -o run.log

#PBS -e err.log

#PBS -j oe

#PBS -l nodes=1:ppn=8

#PBS -l walltime=9999:00:00

#PBS -q batch

#PBS -V

#PBS -S /bin/bash

genome_index=$1
read1=$2
read2=$3
sample=$4

# align RNA-seq reads to genome
hisat2 -q -x $genome_index -1 $read1 -2 $read2  -S $sample.sam -p 4
samtools view -bS $sample.sam |samtools sort -@ 4 -o $sample.sorted.bam -

# count reads
featureCounts -C  -p -g Parent -a ref.gff3 -O -T 2 -o $sample.count $sample.sorted.bam
