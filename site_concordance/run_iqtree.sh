#!/bin/bash

iqtree2 \
    -t data/RAxML_bipartitions.Ts_HQ+ref+Mt.phy.ML1000.BS1000 \
    -s data/alignments/Ts_HQ+ref+Mt.phy.phy \
    --scf 100 \
    --prefix snp_site_concordance_v2 \
    > snp_site_concordance_v2.log 2>&1 
