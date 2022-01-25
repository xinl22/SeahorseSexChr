#!/bin/sh

#PBS -N gwas

#PBS -l nodes=1:ppn=16
#PBS -l walltime=9999:00:00
#PBS -o run_log.$PBS_JOBID
#PBS -e run_out.$PBS_JOBID
#PBS -q batch
#PBS -V
#PBS -S /bin/bash

cd $PBS_O_WORKDIR
perl ./getsnpplink.pl snp.sample snp.haps snp.map snp.ped
plink --file snp --out snp --make-bed --allow-extra-chr --allow-no-sex
plink --bfile snp --chr-set 21 --allow-extra-chr --allow-no-sex --recode 12 transpose --output-missing-genotype 0 --out snp
plink --bfile snp --chr-set 21 --allow-extra-chr --pca --out snp
awk '{print $1,$2,$6}' snp.tfam > snp.pheno
emmax-kin -v -h -s -d 10 snp
emmax-kin -v -h -d 10 snp
emmax -v -d 10 -t snp -p snp.pheno -k snp.hIBS.kinf  -o snp.hIBS
emmax -v -d 10 -t snp -p snp.pheno -k snp.hBN.kinf  -o snp.hBN
 