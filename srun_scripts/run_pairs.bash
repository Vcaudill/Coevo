#!/usr/bin/env bash

sigma=( 0.1 0.2 0.3 0.1 0.2 0.3)
mu_rate=( 6.25e-10 1.56e-10 6.94e-11 1e-10 2.5e-11 1.11e-11)
base_tag="params"

#for i in {1..5}
#do
for index in ${!sigma[*]}; do 
	FN=$(openssl rand 4 | od -DAn)
	tag="${base_tag}_FN_${FN}_"
  echo "${sigma[$index]} and ${mu_rate[$index]} and the tag is ${tag} this is FN ${FN}"
done; done