# _Trachymyrmex septentrionalis_ SNP-based phylogenetic tree construction using RAxML

## Run the bash script, which should build the partition file for RAxML and run RAxML
```{bash}
bash src/ascb_RAxML_run.sh
```

## Convert file to `.nexus` format
The file in `output/raxml/` prefixed with `RAxML_bipartitionsBranchLabels` was converted to `.nexus` format for further downstream analyses. This file converted to `.nexus` is copied to `../Tsept_CophylogeneticSignal_coevo/data/Trachymyrmex_septentrionalis_GBS-SNP_Beigel2025.nexus` for analysis in R.
