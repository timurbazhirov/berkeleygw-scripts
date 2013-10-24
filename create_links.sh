#!/usr/bin/env bash
# Linking the wfn files (output of pw2bgw)
# to the dir where epsilon calc is run

CURdir=`pwd`
TMPdir="$CURdir/_outdir"

ln -s $TMPdir/wfn.cmp ./07-epsilon/WFN
ln -s $TMPdir/wfn.cmp ./07-epsilon/WFNq

ln -s $TMPdir/wfn.cmp_fine ./07-epsilon_fine/WFN
ln -s $TMPdir/wfn.cmp_fine ./07-epsilon_fine/WFNq

ln -s $TMPdir/wfn.cmp ./08-sigma/WFN_inner
ln -s $TMPdir/RHO ./08-sigma/RHO
ln -s $TMPdir/VXC ./08-sigma/VXC
ln -s $CURdir/07-epsilon/epsmat ./08-sigma/epsmat
ln -s $CURdir/07-epsilon_fine/eps0mat ./08-sigma/eps0mat