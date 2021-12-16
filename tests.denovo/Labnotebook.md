Trimming adaptors with fastp: 

```
#run commands SLURM's srun

for FILE in Rutilus/*.fq.gz; do
    NAME=`echo "$FILE" | cut -d'.' -f1`
    READ1=$NAME.1.fq.gz
    READ2=$NAME.2.fq.gz
    srun ./fastp/fastp -i $READ1 -I $READ2 -o $NAME.R1.fq.gz -O $NAME.R2.fq.gz --dont_overwrite --disable_quality_filtering --disable_length_filtering --detect_adapter_for_pe --dont_eval_duplication --thread 15 -h $NAME.fastp.html -j $NAME.fastp.json
done

```

Renaming result 

```
for FILE in Rutilus/*.fq.gz; do
    NAME=`echo "$FILE" | cut -d'.' -f1`
    srun mv Rutilus/$NAME.trimmed.R1.fq.gz Rutilus/$NAME.1.fq.gz
    srun mv Rutilus/$NAME.trimmed.R2.fq.gz Rutilus/$NAME.2.fq.gz
done
```

Counting reads

```
import numpy as np
import os
import pandas as pd
#from Bio import SeqIO
import gzip

files = []

for file in os.listdir("./Rutilus"):
    if file.endswith(".fq.gz"):
        files.append(file)

def count_reads(file):
    with  gzip.open("./Rutilus/"+file, "rt") as handle:
        counter = 0
        for line in handle:
            counter+=1
        return(counter/4)

counts = [count_reads(file) for file in files]

files_counts_df = pd.DataFrame({
  'file': [file.split('.')[0] for file in files],
  'count': counts})

files_counts_df.to_csv("read_counts.tsv", sep="\t")
```

Building plots for read count - in Tables.Rmd

Trying to run `denovo_map.pl` for trimmed reads (Rutilus_analysis/Rutilus contains trimmed reads): 

```
for m in 1 2 3 4 5 6 7 8 9 10; do

        mkdir stacks45.m$m
        mkdir ./stacks45.m$m/populations.r80
        srun denovo_map.pl -m $m -o ./stacks45.m$m --popmap ../info/test_popmap.tsv --samples ../Rutilus --threads 30 -M 2 -n 0 --paired -X "ustacks: --max_locus_stacks 7"
        srun populations --in-path ./stacks45.m$m --out-path ./stacks45.m$m/populations.r80 -r 0.80 &> populations.oe --threads 30

done
```


This prodced an error
```
Error: different sequence lengths detected, this will interfere with Stacks algorithms, trim reads to uniform length
```

Trying m optimization with the raw data (../../Rutilus is a dir with raw reads): 
```
module load stacks

#run commands on SLURM's srun

# runs stacks denovo_map for m from to 10, n=0 and M =2, and --max_locus_stacks 7
# it will process all the samples from test_popmap

for m in 1 2 3 4 5 6 7 8 9 10; do

        mkdir stacks45.m$m
        mkdir ./stacks45.m$m/populations.r80
        srun denovo_map.pl -m $m -o ./stacks45.m$m --popmap ../info/test_popmap.tsv --samples ../../Rutilus --threads 30 -M 2 -n 0 --paired -X "ustacks: --max_locus_stacks 7"
        srun populations --in-path ./stacks45.m$m --out-path ./stacks45.m$m/populations.r80 -r 0.80 &> populations.oe --threads 30

done
```