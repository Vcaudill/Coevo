#!/usr/bin/env bash

input='/Users/victoria/Desktop/slimtestvarables.csv'

while IFS="," read -r trial snake_mu_rate newt_mu_rate snake_mu_effect_sd newt_mu_effect_sd more_mu;
do 
	echo "Trial-$trial"
	echo "snake_mu_rate-$snake_mu_rate"
	echo "newt_mu_rate-$newt_mu_rate"
	echo "snake_mu_effect_sd-$snake_mu_effect_sd"
	echo "newt_mu_effect_sd-$newt_mu_effect_sd"
	echo "more_mu-$more_mu"
done < <(tail -n +2 "$input") # skip the header line