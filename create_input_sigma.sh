#!/usr/bin/env bash
#
# This is a wrapper for Berkeley GW calculation with ESPRESSO
# Creates the input files using the templates in input_templates dir
# ./input_templates/sigma.inp
# TBZ

####------------------------------------####
#### Create input file for sigma        ####
####------------------------------------####
echo "Create input file for sigma"
# start with coulomb cutoffs
# make them equal to the epsilon cutoff and wfn cutoff
EPSCUT=`cat ./input_templates/epsilon.inp | grep "epsilon_cutoff" | awk '{print $2}'`
WFNCUT=`cat ./input_templates/espresso.inp | grep "ecut" | awk '{print $3}'`
echo "screened_coulomb_cutoff $EPSCUT" > ./08-sigma/sigma.inp
echo "bare_coulomb_cutoff $WFNCUT" >> ./08-sigma/sigma.inp
# use the template
cat ./input_templates/sigma.inp >> ./08-sigma/sigma.inp
# get the kpoints
tail +3 00-kgrid/WFN_coarse.out | awk '{print $1 "  " $2 "  " $3 "  1.0"}' > ./tmp
NKPTS=`wc ./tmp | awk '{print $1}'`
# end with kpoints
echo "dont_use_vxcdat" >> ./08-sigma/sigma.inp
echo "number_kpoints $NKPTS" >> ./08-sigma/sigma.inp
echo "begin kpoints" >> ./08-sigma/sigma.inp
cat ./tmp >> ./08-sigma/sigma.inp
echo "end" >> ./08-sigma/sigma.inp
rm ./tmp
