#!/bin/bash
date

# Input phylip name
input_phylip=("$1")

# what to call the output files
run_name="Ts_HQ+ref+Mt"

# number of threads for RAxML
thread_num=32

# Number of ML searches for RAxML
ML_num=1000

# number of bootstrap replicates for RAxML
BS_num=1000

echo "Input PHYLIP: "
echo $input_phylip

echo "Name for this run: "
echo $run_name

# run ascbias.py from raxml_ascbias.py github.com/btmartin721/raxml_ascbias
python ascbias.py -p "input/$input_phylip" -o "output/ascbias/$run_name.phy"

## make partition file
ascb_aln_len=$(awk 'NR==1 {print $2; exit}' output/ascbias/$run_name.phy)

echo "[asc~$run_name.phy.felsenstein], ASC_DNA, p1=1-" > output/ascbias/part.txt
truncate -s-1 output/ascbias/part.txt
echo -n $ascb_aln_len >> output/ascbias/part.txt

## run maximum likelihood search using RAxML
raxmlHPC-PTHREADS-SSE3 -T $thread_num -f d -# $ML_num -p 12345 -m ASC_GTRGAMMA --asc-corr=felsenstein -q output/ascbias/part.txt -s output/ascbias/$run_name.phy -n output/raxml/$run_name.ML$ML_num.txt

## run boostraps
raxmlHPC-PTHREADS-SSE3 -# $BS_num -T $thread_num -x 12345 -p 23445 -e 0.001 -m ASC_GTRGAMMA --asc-corr=felsenstein -q output/ascbias/part.txt -s output/ascbias/$run_name.phy -n output/raxml/$run_name.BS$BS_num.txt

raxmlHPC-PTHREADS-SSE3 -T $thread_num -f b -p 12234 -m ASC_GTRGAMMA -t output/raxml/RAxML_bestTree.$run_name.ML$ML_num.txt -z output/raxml/RAxML_bootstrap.$run_name.BS$BS_num.txt -n output/raxml/$run_name.ML$ML_num.BS$BS_num