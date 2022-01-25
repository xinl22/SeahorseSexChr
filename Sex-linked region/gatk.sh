#!/bin/sh

#PBS -N gatk

#PBS -o run.log

#PBS -e err.log

#PBS -j oe

#PBS -l nodes=1:ppn=8

#PBS -l walltime=9999:00:00

#PBS -q batch

#PBS -V

#PBS -S /bin/bash

cd $PBS_O_WORKDIR

ref=ref.fasta
sample=$1

samtools faidx ref.fasta
java -jar picard.jar CreateSequenceDictionary R=ref.fasta O=ChrAsm.dict
java -jar picard.jar MarkDuplicates I=$ref.$sample.sorted.bam O=$ref.$sample.dedup.bam M=$sample.m
samtools index $ref.$sample.dedup.bam
java -jar picard.jar AddOrReplaceReadGroups I=$ref.$sample.dedup.bam O=$ref.$sample.dedup.bam.rg.bam RGID=4$sample RGLB=lib$sample RGPU=unit1 RGSM=$sample RGPL=illumina

samtools index $ref.$sample.dedup.bam.rg.bam

java -Xmx83g  -jar GenomeAnalysisTK.jar -T HaplotypeCaller -R ref.fasta -I $ref.$sample.dedup.bam.rg.bam --emitRefConfidence GVCF -o $ref.$sample.dedup.bam.rg.bam.g.vcf.gz -nct 12


