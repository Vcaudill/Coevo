datadir=" /Users/victoria/Desktop/Coevo/newt_snake/data" # where the file will be 
snake_mu_rate=( 1e-6 1e-8 1e-10 1e-12 1e-6 1e-8 1e-10 1e-12 1e-6 1e-8 1e-10 1e-12 1e-6 1e-8 1e-10 1e-12)
newt_mu_rate=( 1e-6 )  # does this need to be 50 times more than the snake?
snake_mu_effect_sd=( 0.01 0.01 0.01 0.01 0.05 0.05 0.05 0.05 0.25 0.25 0.25 0.25 0.5 0.5 0.5 0.5)
newt_mu_effect_sd=( 0.01 )
MIN=0
MAX=12345


for i in 1;
do for j in "${newt_mu_rate[@]}";
do for k in "${newt_mu_effect_sd[@]}";

do myfile="${datadir}/both_su_${snake_mu_rate[i-1]}_nu_${j}_sue_${snake_mu_effect_sd[i-1]}_nue_${k}.init.trees"
#FN=$(( $RANDOM % ($MAX + 1 - $MIN) + $MIN ))
FN=$(openssl rand 4 | od -DAn)
namebase="su_${snake_mu_rate[i-1]}_nu_${j}_sue_${snake_mu_effect_sd[i-1]}_nue_${k}"
#"openssl rand(-hex4)"

bash /Users/victoria/Desktop/runsllim.txt ${snake_mu_rate[i-1]} ${j} ${snake_mu_effect_sd[i-1]} ${k/snake_mu_effect_sd[i-1]} ${myfile} ${datadir} ${namebase} ${FN}  
#do python '/Users/victoria/Desktop/Coevo/msprime/snake_newt_gv_.py' ${1} ${2} ${3} ${4} ${5} 
done; done; done