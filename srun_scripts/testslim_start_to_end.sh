#!/usr/bin/env bash

# Run these comands while in The Coevo folder
# might have to run python ans slim one at a time?
datadir="data/test" # directory to store the test files
[ ! -d "$datadir" ] && mkdir -p "$datadir"

outpath="data/test/text_files/" # the text output will be here
[ ! -d "$outpath" ] && mkdir -p "$outpath"
treename="data/test/tree_files/" # the tree output will be here
[ ! -d "$treename" ] && mkdir -p "$treename"
tag="test" # exrta info to identify what experiment I am workin on

# Sample paramiter values
snake_mu_rate=1E-10	
newt_mu_rate=1E-10
snake_mu_effect_sd=0.1
newt_mu_effect_sd=0.1
# the msprime file that slim uses (gennerates sgv)
msprime_file="${datadir}/both_1000_su_${snake_mu_rate}_nu_${newt_mu_rate}_sue_${snake_mu_effect_sd}_nue_${newt_mu_effect_sd}_${tag}.init.trees"
# help to name the slime file with the paramiters that I use
namebase="test_su_${snake_mu_rate}_nu_${newt_mu_rate}_sue_${snake_mu_effect_sd}_nue_${newt_mu_effect_sd}"

# the python script to generate diversity 
python 'msprime/test_snake_newt_msprime.py' ${snake_mu_rate} ${newt_mu_rate} ${snake_mu_effect_sd} ${newt_mu_effect_sd} ${datadir} ${tag}

# the spatial slim script that goes to 1000 generations
slim -m -t -d "mu_rate = ${snake_mu_rate}" -d "newt_mu_rate = ${newt_mu_rate}" -d "snake_mu_effect_sd = ${snake_mu_effect_sd}" -d "newt_mu_effect_sd = ${newt_mu_effect_sd}" -d "msprime_file = '${msprime_file}'" -d "outpath = '${outpath}'" 'newt_snake/test_newt_snake_1on1.slim' > ${treename}/file_${namebase}_${tag}.txt;
