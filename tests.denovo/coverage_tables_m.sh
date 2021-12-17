##!/bin/bash

for m in 1 2 3 4 5 6 7 8 9 10
do
	cat stacks45.m.summary/stacks45.m$m/denovo_map.log | egrep -i '^Sample [0-9]|Stack coverage: mean=|Final coverage: mean='| sed "s/'/=/g" |  sed "s/;/=/g"| awk '{print $2}' FS='=' | xargs -n3 -d'\n' | sed "s/ /,/g" | sed -e "s/^/$m,/" > ./coverage_table_m$m.csv
done
cat coverage_table_m*.csv > coverage_table_m.csv
rm coverage_table_m?*.csv