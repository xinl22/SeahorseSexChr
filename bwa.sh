#!/bin/sh

#PBS -N bwa

#PBS -o run.log

#PBS -e err.log

#PBS -j oe

#PBS -l nodes=1:ppn=8

#PBS -l walltime=9999:00:00

#PBS -q batch

#PBS -V

#PBS -S /bin/bash

genome=$1
read1=$2
read2=$3
sample=$4
cpu=8


bwa mem -t $cpu $genome $read1 $read2  |  samtools sort -@ $cpu  -O BAM -o $genome.$sample.sorted.bam  -

samtools index $genome.$sample.sorted.bam




