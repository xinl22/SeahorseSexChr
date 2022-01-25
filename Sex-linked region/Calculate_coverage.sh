#!/bin/sh

#PBS -N call_cov

#PBS -o run.log

#PBS -e err.log

#PBS -j oe

#PBS -l nodes=1:ppn=12

#PBS -l walltime=9999:00:00

#PBS -q batch

#PBS -V

#PBS -S /bin/bash

cd $PBS_O_WORKDIR

samtools merge femalemerged.bam *.female*.bam
samtools index femalemerged.bam
samtools merge malemerged.bam *.male*.bam
samtools index malemerged.bam
/share/workplace/nfhy_chenjn/longxin/rerun/03.gatk/sorted_bam/sambamba-0.7.0-linux-static depth window  --overlap 2500 -w 5000 -o female5k.txt -t 4 -q=20 femalemerged.bam
/share/workplace/nfhy_chenjn/longxin/rerun/03.gatk/sorted_bam/sambamba-0.7.0-linux-static depth window  --overlap 2500 -w 5000 -o male5k.txt -t 4 -q=20 malemerged.bam
