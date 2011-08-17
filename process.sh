#!/bin/bash



mylist="E80_00876 E80_07977 E80_12098 E80_18495 E80_21101 E80_21228 E80_23898 E80_25072 E80_26619 E80_26928 E80_27403 E80_35753"


for a in $mylist
do
	echo $a
	bash convert_original_gene.sh $a
	bash register_gene_to_waxholm_3d.sh $a
done;

