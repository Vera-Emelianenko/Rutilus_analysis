##!/bin/bash

for M in 1 2 3 4 5 6 7 8
do
	cat stacks45.Mn.summary/stacks45.Mn$M/populations.r80/populations.log.distribs| sed -n '/^BEGIN snps_per_loc_postfilters/,${p;/^END/q}' | sed '1d;2d;3d;$d'| sed -e "s/^/$M\t/"  > ./snps_per_locus_Mn$M.tsv
done
cat snps_per_locus_Mn*.tsv > snps_per_locus_Mn.tsv
rm snps_per_locus_Mn?*.tsv