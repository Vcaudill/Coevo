#!/usr/bin/env bash
#SBATCH --account=kernlab          ### SLURM account which will be charged for the job
#SBATCH --partition=kern        ### Partition (like a queue in PBS)
#SBATCH --job-name=1000      ### Job Name
#SBATCH --output=1000.out         ### File in which to store job output
#SBATCH --error=1000.err          ### File in which to store job error messages
#SBATCH --time=0-01:00:00       ### Wall clock time limit in Days-HH:MM:SS
#SBATCH --nodes=1               ### Node count required for the job
#SBATCH --ntasks-per-node=1     ### Nuber of tasks to be launched per Node
#SBATCH --cpus-per-task=1       ### Number of cpus (cores) per task
#SBATCH --mem-per-cpu=128G

outpath="/home/vcaudill/kernlab/coevo/Expdata/text_files"
myfile="/home/vcaudill/kernlab/coevo/MSprome_sim/both_su_1e-10_nu_1e-10_sue_0.01_nue_0.01.init.trees"

if [ ! -d "/home/vcaudill/kernlab/coevo/pheno_test_1000" ] 
then
    mkdir "/home/vcaudill/kernlab/coevo/pheno_test_1000"
    mkdir "/home/vcaudill/kernlab/coevo/pheno_test_1000/text_files"
    mkdir "/home/vcaudill/kernlab/coevo/pheno_test_1000/tree_files"
    exit 
fi

input='/home/vcaudill/kernlab/coevo/SLiM_script/slimtestvarables.csv'

while IFS="," read -r trial snake_mu_rate newt_mu_rate snake_mu_effect_sd newt_mu_effect_sd more_mu;
do 
echo ${trial}
FN=$(openssl rand 4 | od -DAn)
namebase="su_${snake_mu_rate}_nu_${newt_mu_rate}_sue_${snake_mu_effect_sd}_nue_${newt_mu_effect_sd}"
treename="/home/vcaudill/kernlab/coevo/Expdata/tree_files/"


sbatch runslim.srun ${snake_mu_rate} ${newt_mu_rate} ${snake_mu_effect_sd} ${newt_mu_effect_sd} ${myfile} ${treename} ${outpath} ${namebase} ${FN}
	
done < <(tail -n +2 "$input") # skip the header line




