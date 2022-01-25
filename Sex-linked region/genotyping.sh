#!/bin/sh

#PBS -N genotyping

#PBS -o run.log

#PBS -e err.log

#PBS -j oe

#PBS -l nodes=1:ppn=20

#PBS -l walltime=9999:00:00

#PBS -q batch

#PBS -V

#PBS -S /bin/bash

cd $PBS_O_WORKDIR

java -jar GenomeAnalysisTK.jar -R ref.fasta -T GenotypeGVCFs --variant female_1.dedup.bam.rg.bam.g.vcf.gz --variant female_2.dedup.bam.rg.bam.g.vcf.gz --variant female_3.dedup.bam.rg.bam.g.vcf.gz --variant female_4.dedup.bam.rg.bam.g.vcf.gz --variant female_5.dedup.bam.rg.bam.g.vcf.gz --variant female_6.dedup.bam.rg.bam.g.vcf.gz --variant female_7.dedup.bam.rg.bam.g.vcf.gz --variant female_8.dedup.bam.rg.bam.g.vcf.gz --variant female_9.dedup.bam.rg.bam.g.vcf.gz --variant female_10.dedup.bam.rg.bam.g.vcf.gz --variant female_11.dedup.bam.rg.bam.g.vcf.gz --variant female_12.dedup.bam.rg.bam.g.vcf.gz --variant female_13.dedup.bam.rg.bam.g.vcf.gz --variant female_14.dedup.bam.rg.bam.g.vcf.gz --variant female_15.dedup.bam.rg.bam.g.vcf.gz --variant female_16.dedup.bam.rg.bam.g.vcf.gz --variant female_17.dedup.bam.rg.bam.g.vcf.gz --variant female_18.dedup.bam.rg.bam.g.vcf.gz --variant female_19.dedup.bam.rg.bam.g.vcf.gz --variant female_20.dedup.bam.rg.bam.g.vcf.gz --variant female_21.dedup.bam.rg.bam.g.vcf.gz --variant female_22.dedup.bam.rg.bam.g.vcf.gz --variant female_23.dedup.bam.rg.bam.g.vcf.gz --variant female_24.dedup.bam.rg.bam.g.vcf.gz --variant female_25.dedup.bam.rg.bam.g.vcf.gz --variant female_26.dedup.bam.rg.bam.g.vcf.gz --variant female_27.dedup.bam.rg.bam.g.vcf.gz --variant female_28.dedup.bam.rg.bam.g.vcf.gz --variant female_29.dedup.bam.rg.bam.g.vcf.gz --variant male_1.dedup.bam.rg.bam.g.vcf.gz --variant male_2.dedup.bam.rg.bam.g.vcf.gz --variant male_3.dedup.bam.rg.bam.g.vcf.gz --variant male_4.dedup.bam.rg.bam.g.vcf.gz --variant male_5.dedup.bam.rg.bam.g.vcf.gz --variant male_6.dedup.bam.rg.bam.g.vcf.gz --variant male_7.dedup.bam.rg.bam.g.vcf.gz --variant male_8.dedup.bam.rg.bam.g.vcf.gz --variant male_9.dedup.bam.rg.bam.g.vcf.gz --variant male_10.dedup.bam.rg.bam.g.vcf.gz --variant male_11.dedup.bam.rg.bam.g.vcf.gz --variant male_12.dedup.bam.rg.bam.g.vcf.gz --variant male_13.dedup.bam.rg.bam.g.vcf.gz --variant male_14.dedup.bam.rg.bam.g.vcf.gz --variant male_15.dedup.bam.rg.bam.g.vcf.gz --variant male_16.dedup.bam.rg.bam.g.vcf.gz --variant male_17.dedup.bam.rg.bam.g.vcf.gz --variant male_18.dedup.bam.rg.bam.g.vcf.gz --variant male_19.dedup.bam.rg.bam.g.vcf.gz --variant male_20.dedup.bam.rg.bam.g.vcf.gz --variant male_21.dedup.bam.rg.bam.g.vcf.gz --variant male_22.dedup.bam.rg.bam.g.vcf.gz --variant male_23.dedup.bam.rg.bam.g.vcf.gz --variant male_24.dedup.bam.rg.bam.g.vcf.gz --variant male_25.dedup.bam.rg.bam.g.vcf.gz --variant male_26.dedup.bam.rg.bam.g.vcf.gz --variant male_27.dedup.bam.rg.bam.g.vcf.gz --variant male_28.dedup.bam.rg.bam.g.vcf.gz --variant male_29.dedup.bam.rg.bam.g.vcf.gz --variant male_30.dedup.bam.rg.bam.g.vcf.gz -o All.raw.vcf.gz

java -Xmx208g  -jar GenomeAnalysisTK.jar -R ref.fasta -T SelectVariants -V All.raw.vcf.gz -selectType SNP -o ref.snp.vcf

java  -Xmx108g -jar GenomeAnalysisTK.jar -R ref.fasta -T VariantFiltration -V ref.snp.vcf --logging_level ERROR --filterExpression " QD < 2.0 || FS > 60.0 || MQRankSum < -12.5 || RedPosRankSum < -8.0 || SOR > 3.0 || MQ < 40.0 " --filterName "my_snp_filter" -o ref.snp.filter.vcf

java  -Xmx108g -jar GenomeAnalysisTK.jar -R ref.fasta -T SelectVariants -V ref.snp.filter.vcf --excludeFiltered -o ref.snp.final.vcf.gz


