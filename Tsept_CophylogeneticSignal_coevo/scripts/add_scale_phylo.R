library(devtools)
devtools::install_github('liamrevell/phytools', quiet = TRUE)

# yulab.utils for R version < 4.2
install.packages("https://mirrors.aliyun.com/CRAN/src/contrib/Archive/yulab.utils/yulab.utils_0.1.4.tar.gz", 
                 repos = NULL, type = "source")

# Install once
BiocManager::install("treeio")

library(treeio)
library(phytools)
library(coevo)

analysis_name = 'antHost_fungusSymbiont'
hs_assoc = read_associations('data/ant-fungus_matrix.tsv')

# Ant phylo
ants = read_phylo(
    filepath = 'data/Trachymyrmex_septentrionalis_GBS-SNP_Beigel2025.nexus',
    nexus_format = 'raxml', 
    taxa_to_keep = hs_assoc$host_taxa,
    label_fix = c('JS_', '')
)

# Fungus phylo
fungus = read_phylo(
    filepath = 'data/Leucocoprinus_sp_Sanger-ITS_Luiso2020.nexus',
    nexus_format = 'raxml', 
    taxa_to_keep = hs_assoc$symbiont_taxa,
    label_fix = c('\\.', '')
)

write.table(
    data.frame(hs_assoc$symbiont_taxa, hs_assoc$host_taxa),
    file = 'results/tables/match_names.txt',
    quote = FALSE,
    row.names = FALSE,
    sep = ','
)

# MANUALLY ADDED INITALDATE IDs
name_map = read.table(
    file = 'results/tables/match_names_edited.txt',
    sep = ',',
    header = TRUE
)

# Read in the site concordance tree
ants_scfs = treeio::read.beast('site_concordance/data/snp_site_concordance_v2.cf.tree.nex')
str(ants_scfs)
ants_scfs@data
ants_scfs@phylo$tip.label
ants_scfs@phylo$tip.label = stringr::str_replace(ants_scfs@phylo$tip.label, 'JS_', '')
ants_scfs@data$label
ants_scfs@data$sCF

library(tidyverse)
tree = ants_scfs
phy <- as.phylo(tree)
ntips <- length(phy$tip.label)

tree_tbl <- as_tibble(tree)

tree_tbl <- tree_tbl %>%
  rename(label = label.x)  # required for as.phylo()

combined_labels <- tree_tbl %>%
  filter(node > ntips) %>%                     # Internal nodes only
  mutate(
  sCF_numeric = as.numeric(sCF),  # new numeric column
  combined_label = ifelse(
    !is.na(sCF_numeric),
    paste0(label.y, "\n_", round(sCF_numeric)),
    as.character(label.y)
  )
) %>%
  arrange(node) %>%
  pull(combined_label)

ants$node.label = combined_labels


# Convert to tibble if not already
tree_tbl <- as_tibble(ants_scfs)
tree_tbl <- tree_tbl %>%
  mutate(
    combined_label = ifelse(
      !is.na(sCF),
      paste0(label, "\nsCF: ", sCF, 2),
      label  # fallback if sCF missing
    )
  )
phy <- as.phylo(tree)

# Number of tips
ntips <- length(phy$tip.label)

# Set internal node labels using combined_label
internal_labels <- tree_tbl %>%
  filter(node > ntips) %>%
  arrange(node) %>%
  pull(combined_label)

phy$node.label <- internal_labels
plot(phy, show.tip.label = TRUE)
nodelabels(phy$node.label, frame = "none", cex = 0.7)



ants_scfs@data$bs_sCF = paste(ants_scfs@data$label, '/', ants_scfs@data$sCF)

ants_scfs_phylo = ants_scfs@phylo

ants_scfs_phylo$node.label = paste(ants_scfs@data$label, '/', ants_scfs@data$sCF)

plot(ants_scfs_phylo)
ants_scfs_phylo = ape::keep.tip(ants_scfs_phylo, ants_scfs_phylo$tip.label[1:30])
plot(ants_scfs_phylo)
ants$tip.label
ants$node.label
ants_scfs_phylo$tip.label
ants_scfs_phylo$node.label

pdf('check_bootstraps.pdf')
plot(ants)
nodelabels(ants$node.label, frame = "none", cex = 0.8)
plot(ants_scfs_phylo)
nodelabels(ants_scfs_phylo$node.label, frame = "none", cex = 0.8)
dev.off()

ants = ants_scfs_phylo

phytools::nodelabels.cophylo(cophy$trees[[1]]$node.label, 
    1:cophy$trees[[1]]$Nnode + ape::Ntip(cophy$trees[[1]]), 
    which = "left", frame = "none", cex = 1, adj = c(1.2, 
        1.2))

tip_rename_vector_ant = setNames(name_map$name.for.fig, name_map$hs_assoc.host_taxa)
tip_rename_vector_fungus = setNames(name_map$name.for.fig, name_map$hs_assoc.symbiont_taxa)

ants$tip.label = unname(tip_rename_vector_ant[ants$tip.label])
fungus$tip.label = unname(tip_rename_vector_fungus[gsub("'", "", fungus$tip.label)])

cophy = cophylo(fungus, ants)

pdf('results/cophylo_with_scalebars.pdf', width = 8, height = 8)
plot(cophy, scale.bar = c(0.2, 0.02))
phytools::nodelabels.cophylo(cophy$trees[[1]]$node.label, 
    1:cophy$trees[[1]]$Nnode + ape::Ntip(cophy$trees[[1]]), 
    which = "left", frame = "none", cex = 0.75, adj = c(1.2, 
        1.2))
phytools::nodelabels.cophylo(cophy$trees[[2]]$node.label, 
    1:cophy$trees[[2]]$Nnode + ape::Ntip(cophy$trees[[2]]), 
    which = "right", frame = "none", cex = 0.75, adj = c(-0.1, 
        1.3))
dev.off()

