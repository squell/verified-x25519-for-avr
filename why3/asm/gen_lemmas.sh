#! /usr/bin/env bash

# generate the rewrite rules to expand 'uint' into a power series; these will be proven in why3, so
# this script is not part of the trusted code base

echo "lemma uint_0:"
echo  "  forall reg, lo. B.sum (reg,lo) 0 0 = 0"
for i in `seq 1 32`; do
	echo "lemma uint_$i:"
	echo -n "  forall reg, lo. B.sum (reg,lo) 0 $i = reg[lo]"
	for j in `seq 2 $i`; do
		echo -n " + pow2 $((8*(j-1)))*reg[lo+$((j-1))]"
	done
	echo
	echo "meta rewrite prop uint_$i"
done
