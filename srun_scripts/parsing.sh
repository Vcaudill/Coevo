#!/usr/bin/env bash

#read -p 'Enter the directory path: ' directory
for file_name in "$1"/*;
do 
arrIN=(${file_name//_/ })

snake_mu_rate=${arrIN[5]}
newt_mu_rate=${arrIN[7]}
snake_mu_effect_sd=${arrIN[9]}
newt_mu_effect_sd_fix==${arrIN[11]}
newt_mu_effect_sd_fix=(${newt_mu_effect_sd_fix//.init/ })
newt_mu_effect_sd=(${newt_mu_effect_sd_fix//=/ })

echo ${snake_mu_rate} ${newt_mu_rate} ${snake_mu_effect_sd} ${newt_mu_effect_sd}
done