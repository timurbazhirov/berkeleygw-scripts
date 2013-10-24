#!/usr/bin/env bash
#
# This is a wrapper for Berkeley GW calculation
# Creates the dir structure for the calculation
# TBZ

for i in _outdir 00-kgrid 01-scf 02-wfn 02-wfn_fine 07-epsilon 07-epsilon_fine
do
  if [ ! -d $i ];
  then
    mkdir $i
  fi
done