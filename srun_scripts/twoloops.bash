
#input="~/Desktop/Coevo/data/slimtestvarables_short.csv"


#read -p 'Enter the directory path: ' directory
for file_name in "$1"/*;
do 
echo ${file_name}



FN=$(openssl rand 4 | od -DAn)
treename="/home/vcaudill/kernlab/coevo/pheno_test_1000_2/tree_files/"
outpath="/home/vcaudill/kernlab/coevo/pheno_test_1000_2/text_files"
done



#while IFS="," read -r trial snake_mu_effect_sd newt_mu_effect_sd snake_mu_rate newt_mu_rate more_mu;
#do 
#FN=$(openssl rand 4 | od -DAn)
#namebase="small_1000_su_${snake_mu_rate}_nu_${newt_mu_rate}_sue_${snake_mu_effect_sd}_nue_${newt_mu_effect_sd}"
#cat($namebase)

#sbatch runslim.srun ${snake_mu_rate} ${newt_mu_rate} ${snake_mu_effect_sd} ${newt_mu_effect_sd} ${file_name} ${treename} ${outpath} ${namebase} ${FN}
#done < <(tail -n +2 "$input")
#done
