# Site concordance factors
From [ref](https://pmc.ncbi.nlm.nih.gov/articles/PMC9477076/):
> The sCF is defined as the average percentage of maximum-parsimony (MP) informative site patterns in quartet-related sub-alignments, supporting a branch x of a given bifurcating and unrooted reference tree. ([18](https://academic.oup.com/mbe/article/37/9/2727/5828940))" 

# Installations
```bash
sudo apt-get install iqtree
```

# Site concordance example
```bash
# infer the concatentated tree with 1000 ultrafast bootstraps and an edge-linked fully-partitioned model (-p is the same as -spp from version 1.7 onwards) 
iqtree -s alignment.nex -p alignment.nex --prefix concat -bb 1000 -nt AUTO

# infer the 88 single-locus trees
iqtree -s alignment.nex -S alignment.nex --prefix loci -nt 50

# calculate concordance factors
iqtree -t concat.treefile --gcf loci.treefile -s alignment.nex --scf 100 --prefix concord
```

# Run site concordance analysis for this project
```bash
iqtree2 \
    -t data/RAxML_bipartitions.Ts_HQ+ref+Mt.phy.ML1000.BS1000 \
    -s data/alignments/Ts_HQ+ref+Mt.phy.phy \
    --scf 100 \
    --prefix snp_site_concordance_v2 \
    > snp_site_concordance_v2.log 2>&1 
```