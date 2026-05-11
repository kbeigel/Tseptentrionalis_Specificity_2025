# Non-reciprocal coevolution in a fungus-gardening ant: Trachymyrmex septentrionalis SNP data and phylogeny, Leucocoprinus sp. ITS phylogeny, and fungal garden growth experiment data

## Variant call and SNP data files from sequencing service

This dataset contains several data files that were generated for our study by SNPsaurus ([https://www.snpsaurus.com/](https://www.snpsaurus.com/)) and Genome GBS Library Preparation Service at the University of Oregon (Eugene, OR), which is where the genome-by-sequencing for this study was done. Please note that the notation 'JSTs' was a naming convention from sequencing, indicating that samples were submitted by the **J**on **S**eal Lab and were ***T**rachymyrmex* ***s**eptentrionalis* samples.

### Files and variables

#### **File:** **`JSTs_stats.txt`**

**Description:** Stats file describing the percentage of reads mapped to reference during alignment in BBTools. This data file was produced by SNPsaurus ([https://www.snpsaurus.com/](https://www.snpsaurus.com/)) and Genome GBS Library Preparation Service at the University of Oregon (Eugene, OR).

#### **File:** **`JSTs.vcf`**

**Description:** VCF file generated from BBTools `callvariants` and filtered with `vcftools`. This data file was produced by SNPsaurus ([https://www.snpsaurus.com/](https://www.snpsaurus.com/)) and Genome GBS Library Preparation Service at the University of Oregon (Eugene, OR).

#### File: `JSTs.phy`

**Description:** PHYLIP file of SNPs identified in `JSTs.vcf`. This data file was produced by SNPsaurus ([https://www.snpsaurus.com/](https://www.snpsaurus.com/)) and Genome GBS Library Preparation Service at the University of Oregon (Eugene, OR).

## SNP and phylogenetic tree files from downstream processing and analysis

The following files are processed/analyzed/derived files from the "Data files from sequencing service" above.

### Files and variables

#### File: `JSTs_HQ_ref_Mt.phy`

**Description:** PHYLIP file with SNP reference nucleotides added and with low-quality samples removed because they had less than two million high-quality reads.

#### File: `Trachymyrmex_septentrionalis_GBS-SNP_Beigel2025.nexus`

**Description:** NEXUS file phylogenetic tree constructed based on genome-wide single nucleotide polymorphisms (SNPs) of 30 *Trachymyrmex septentrionalis* ants (associated with 30 of the *Leucocoprinus sp.* taxa in `Leucocoprinus_sp_Sanger-ITS_Luiso2020.nexus`) and SNPs from one reference taxon (T_sept_ref, from NCBI BioProject PRJNA343973 and BioSample SAMN03982881).

## Data files based on data from a previous study with related data

The following file is based on data from a previous study:

* Luiso J, Kellner K, Matthews AE, Mueller UG, Seal JN. High diversity and multiple invasions to North America by fungi grown by the northern-most Trachymyrmex and Mycetomoellerius ant species. Fungal Ecology. 2020;44:100878.

Luiso et al. 2020 sequenced the ITS gene of fungi in order to genotype and construct a fungal phylogeny. The distances from this fungal phylogeny were used in downstream analyses of cophylogenetic signal.

### Files and variables

#### File: `Leucocoprinus_sp_Sanger-ITS_Luiso2020.nexus`

**Description:** NEXUS file of the *Leucocoprinus sp.* fungi associated with *Trachymyrmex septentrionalis*. This full phylogeny is shown in the cophylogeny in Figure S1.

## Data file showing associations between taxa in ant and fungal phylogenies

The following data file is used to show the associations between ant and fungus taxa.

### Files and variables

#### File: `Trachymyrmex-septentrionalis_Leucocoprinus-sp_Associations.txt`

**Description:** The 'Ant' taxa listed in this file correspond to the taxa in `Trachymyrmex_septentrionalis_GBS-SNP_Beigel2025.nexus`. The 'Fungus' taxa listed in this file correspond to the taxa in `Leucocoprinus_sp_Sanger-ITS_Luiso2020.nexus`. Each row of Ant and Fungus taxa indicate that those specific ant and fungus samples are from the same colony.

## Data file showing ParaFit and PACo links

The file shows the significant links determined by ParaFit and PACo. This data is shown in Figure 2.

### Files and variables

#### File: `CombinedRes_ParaFit-FH-AS_PACo-AH-FS_coevo_global_results.txt`

**Description:** See `copyhlogenetic_signal/Tsept_NonReciprocalCoevo_2025.Rmd` for methods of running tests of cophylogenetic signal. This analysis was performed using the mini-package available at [github.com/kbeigel/coevo](https://github.com/kbeigel/coevo); see vignette/example for explanation of columns in table.

---

## Code/software

Initial processing to generate the PHYLIP file:

Informatics were performed by SNPsaurus. Demultiplexed reads were trimmed using bbduk in BBTools. For alignment, a published genome of T. septentrionalis (NCBI BioProject PRJNA343973 and BioSample SAMN03982881) was used as the reference genome. Trimmed reads were aligned to the reference with a 95% identity threshold for mapping and tossing of ambiguously mapped reads. In BBTools, callvariants was used for variant calling with a mapping quality threshold of 15. Called variants were filtered using vcftools for a depth of 8 or greater and a minimum allele frequency of 5%. The resulting variant call file had 26,519 nucleotides.

### 1. Phylogenetic tree estimation using RAxML

Code and methods are available here: [github.com/kbeigel/Tseptentrionalis_Specificity_2025](https://github.com/kbeigel/Tseptentrionalis_Specificity_2025)

See `phylogenetic_analysis/Tsept_PhylogeneticTree_RAxML.md` for methods for running RAxML.

#### Description:

##### Sample quality control and phylogenetic estimation

The nucleotides of the *T. septentrionalis* reference sequence were extracted from the original variant call format file using described methods (1). In Mesquite (v. 3.61) the resulting SNP reference was added to the PHYLIP file of sample SNPs. Ambiguous (invariant) sites were removed using a Python script (ascbias.py from github.com/btmartin721/raxml_ascbias) to prepare files for phylogenetic estimation in RAxML (2). After removal of ambiguous sites, the dataset had 7,493 nucleotides (compared to 26,519 nucleotides prior to removal of ambiguous sites). RAxML (v. 8.2.11) was then used to estimate a maximum likelihood phylogeny for* T*. septentrionalis with ascertainment bias correction (Felsenstein method) and 1000 bootstrap replicates (2).

### 2. Evaluating cophylogenetic signal between *T. septentrionalis* and *Leucocoprinus sp.*

The input files here can be used to run tests of cophylogenetic signal. Code and methods are available here in the GitHub respotory for this project: [github.com/kbeigel/Tseptentrionalis_Specificity_2025](https://github.com/kbeigel/Tseptentrionalis_Specificity_2025). The project repository contains a `renv.lock` file (for using the [renv](https://rstudio.github.io/renv/articles/renv.html) environment management package) that contains information on all packages and versions used in R for analysis.

See `copyhlogenetic_signal/Tsept_NonReciprocalCoevo_2025.Rmd` for methods of running tests of cophylogenetic signal. This analysis was performed using the mini-package available at [github.com/kbeigel/coevo](https://github.com/kbeigel/coevo)  (v1.0.0).

#### Description:

##### Cophylogenetic signal

To examine the cophylogenetic signal between ant and fungal phylogenies, the cophylogenetic statistical tests ParaFit and PACo were used (3, 4). Both ParaFit and PACo test the degree of cophylogenetic signal between host and symbiont (parasite) based on the patristic distances of the host and symbiont phylogenies (5).

ParaFit is a cophylogenetic analysis method that uses patristic distances to evaluate the degree of cophylogenetic signal between two groups of organisms (6). ParaFit tests for cophylogenetic signal using a null hypothesis that the associations between hosts and symbionts are random (i.e., independent). A significant global p-value in ParaFit suggests that the host-symbiont associations are non-random. ParaFit also tests individual host-symbiont associations, and a significant p-value for a host-symbiont association indicates that the association contributes to the global fit test statistic. ParaFit analyses were run using custom R code (see [github.com/kbeigel/coevo](https://github.com/kbeigel/coevo)). In brief, ParaFit was run 100 times, with 999 permutations per run. Each run of ParaFit used the ‘lingoes’ correction method for negative eigenvalues. The p-values from all ParaFit runs were adjusted using the Benjamini-Hochberg correction for false discovery rate (7, 8). The p-values for the ParaFit global test statistic and the p-values for each link are the means of all Benjamini–Hochberg (BH) adjusted p-values from all ParaFit runs. ParaFit was run in R using the packages ape (v5.0), phangorn (v2.5.5), and phytools (v0.7-70).

PACo, like ParaFit, evaluates the level of cophylogenetic signal between two phylogenies based on pairwise patristic distance matrices. In contrast to ParaFit, PACo uses Procrustean superimposition to transform and scale the symbiont matrix to fit the host matrix and tests whether the speciation of the symbiont is driven by host speciation (9) . In other words, PACo tests the dependence of the symbiont’s phylogenetic variation of the host’s phylogenetic variation. A significant global fit p-value indicates that the host is driving symbiont evolution. PACo was run with 100,000 permutations and a ‘cailliez’ correction for negative eigenvalues. PACo was run in R using the packages ape (v5.0), phangorn (v2.5.5), and vegan (v2.6-2).

### References

1. Beigel K, Matthews AE, Kellner K, Pawlik C, Greenwold M, Seal JN. Cophylogenetic analyses of ant-fungal specificity: 'One to one with some exceptions'. Molecular Ecology. 2021;30:5605–20.
2. Stamatakis A. RAxML version 8: a tool for phylogenetic analysis and post-analysis of large phylogenies. Bioinformatics. 2014 May 1;30(9):1312-3. PubMed PMID: 24451623. Pubmed Central PMCID: PMC3998144. Epub 2014/01/24. eng.
3. Balbuena JA, Míguez-Lozano R, Blasco-Costa I. PACo: A Novel Procrustes Application to Cophylogenetic Analysis. PLoS ONE. 2013;8(4):e61048.
4. Legendre P, René, Mireille L. Harmelin-Vivien. Relating behavior to habitat: solutions to the fourth-corner problem. Ecology. 1997;78(2):547-62.
5. Blasco-Costa I, Hayward A, Poulin R, Balbuena JA. Next-generation cophylogeny: unravelling eco-evolutionary processes. Trends Ecol Evol. 2021 2021/10/01/;36(10):907-18.
6. Legendre P, Desdevises Y, Bazin E. A statistical test for host-parasite coevolution. Syst Biol. 2002 Apr;51(2):217-34. PubMed PMID: 12028729. Epub 2002/05/25. eng.
7. Matthews AE, Klimov PB, Proctor HC, Dowling APG, Diener L, Hager SB, et al. Cophylogenetic assessment of New World warblers (Parulidae) and their symbiotic feather mites (Proctophyllodidae). Journal of Avian Biology. 2018;49(3):jav-01580
8. Benjamini Y, Hochberg Y. Controlling the False Discovery Rate: A Practical and Powerful Approach to Multiple Testing. Journal of the Royal Statistical Society: Series B (Methodological). 1995 1995/01/01;57(1):289-300.
9. Balbuena JA, Míguez-Lozano R, Blasco-Costa I. PACo: A Novel Procrustes Application to Cophylogenetic Analysis. PLoS ONE. 2013;8(4):e61048.

---

## Access information

Other publicly accessible locations of the data:

* Code and methods are available here: [github.com/kbeigel/Tseptentrionalis_Specificity_2025](https://github.com/kbeigel/Tseptentrionalis_Specificity_2025)
* *Trachymyrmex septentrionalis* genome used as the reference for variant calling and the outgroup for phylogenetic tree construction is available at: [NCBI BioProject PRJNA343973](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA343973/) and [BioSample SAMN03982881](https://www.ncbi.nlm.nih.gov/biosample?Db=biosample&DbFrom=bioproject&Cmd=Link&LinkName=bioproject_biosample&LinkReadableName=BioSample&ordinalpos=1&IdsFromResult=343973)
* *Trachymyrmex septentrionalis* whole genome sequencing samples are available at: [NCBI BioProject ID PRJNA1192567](https://dataview.ncbi.nlm.nih.gov/object/PRJNA1192567?reviewer=vmhe7icu6t4mj2b7bk6pukm4nu)
* *Leucocoprinus sp.* ITS sequences from Luiso et al. 2020 are available on GenBank. Accessions are listed in the Luiso et al. 2020 supplemental data.
  * Citation: Luiso J, Kellner K, Matthews AE, Mueller UG, Seal JN. High diversity and multiple invasions to North America by fungi grown by the northern-most Trachymyrmex and Mycetomoellerius ant species. Fungal Ecology. 2020;44:100878. u.

