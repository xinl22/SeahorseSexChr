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

# imputation and phasing
for i in {1..21}
do
vcftools --vcf ref.snp.final.vcf --chr Chr${i}  --maf 0.05 --recode --recode-INFO-all --out chr${i}

java -Xmx100G -jar beagle.28Sep18.793.jar gt=chr${i}.recode.vcf out=chr${i}_snp.IM nthreads=4

gunzip chr${i}_snp.IM.vcf.gz

awk '$1~/#/ || $5!~/,/' chr${i}_snp.IM.vcf > chr${i}_snp.IM.bi.vcf

shapeit -V chr${i}_snp.IM.bi.vcf --window 0.5 -O chr${i}_snp.IM.Ph --thread 4

done

for i in {1..21}; do cat chr${i}_snp.IM.Ph.haps >>snp.haps; done

# convert format
perl ./getsnpplink.pl snp.sample snp.haps snp.map snp.ped
plink --file snp --out snp --make-bed --allow-extra-chr --allow-no-sex

# generate tped/tfam
plink --bfile snp --chr-set 21 --allow-extra-chr --allow-no-sex --recode 12 transpose --output-missing-genotype 0 --out snp
plink --bfile snp --chr-set 21 --allow-extra-chr --pca --out snp

# generate phenotype file
awk '{print $1,$2,$6}' snp.tfam > snp.pheno

#run emmax and use snp.hBN as final result.
emmax-kin -v -h -s -d 10 snp
emmax-kin -v -h -d 10 snp
emmax -v -d 10 -t snp -p snp.pheno -k snp.hIBS.kinf  -o snp.hIBS
emmax -v -d 10 -t snp -p snp.pheno -k snp.hBN.kinf  -o snp.hBN
 
