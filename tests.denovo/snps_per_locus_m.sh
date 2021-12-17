##!/bin/bash

for m in 1 2 3 4 5 6 7 8 9 10
do
	cat stacks45.m.summary/stacks45.m$m/populations.r80/populations.log.distribs| sed -n '/^BEGIN snps_per_loc_postfilters/,${p;/^END/q}' | sed '1d;2d;3d;$d'| sed -e "s/^/$m\t/"  > ./snps_per_locus_m$m.tsv
done
cat snps_per_locus_m*.tsv > snps_per_locus_m.tsv
rm snps_per_locus_m?*.tsv