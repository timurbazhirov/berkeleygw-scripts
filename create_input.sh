#!/usr/bin/env bash
#
# This is a wrapper for Berkeley GW calculation with ESPRESSO
# Creates the input files using the templates in input_templates dir
# ./input_templates/espresso.inp
# ./input_templates/epsilon.inp
# TBZ

KGRID="$HOME/BGW/BerkeleyGW/bin/kgrid.x"
NKX=16
NKY=16
NKZ=1
NKX_fine=64
NKY_fine=64
NKZ_fine=1
####----------------------------------------####
#### Create the input files for the k-grids ####
####----------------------------------------####
cat > 00-kgrid/WFN_coarse.in <<EOF
$NKX $NKY $NKZ
0.0 0.0 0.0
0.0 0.0 0.0

1.0  0.0 0.0
0.0  1.0 0.0
0.0  0.0 0.687285
4
1      0.75   0.25   0.000000000
2      0.25   0.25   0.1990
2      0.75   0.75  -0.1990
1      0.25   0.75   0.000000000
25 25 40
.false.
EOF
cat > 00-kgrid/WFN_fine.in <<EOF
$NKX_fine $NKY_fine $NKZ_fine
0.0 0.0 0.0
0.0 0.0 0.0

1.0  0.0 0.0
0.0  1.0 0.0
0.0  0.0 0.687285
4
1      0.75   0.25   0.000000000
2      0.25   0.25   0.1990
2      0.75   0.75  -0.1990
1      0.25   0.75   0.000000000
25 25 40
.false.
EOF
####-----------------------------------------------####
#### Create input files for wavefunction converter ####
####-----------------------------------------------####
echo "Create input files for wavefunction converter"
cat > 02-wfn/pp_in <<EOF
&input_pw2bgw
   prefix = 'pref'
   real_or_complex = 2
   wfng_flag = .true.
   wfng_file = 'wfn.cmp'
   wfng_kgrid = .true.
   wfng_nk1 = $NKX
   wfng_nk2 = $NKY
   wfng_nk3 = $NKZ 
   wfng_dk1 = 0.0
   wfng_dk2 = 0.0
   wfng_dk3 = 0.0
   rhog_flag = .true.
   rhog_file = 'RHO'
   vxcg_flag = .true.
   vxcg_file = 'VXC'
/
EOF
cat > 02-wfn_fine/pp_in <<EOF
&input_pw2bgw
   prefix = 'pref'
   real_or_complex = 2
   wfng_flag = .true.
   wfng_file = 'wfn.cmp_fine'
   wfng_kgrid = .true.
   wfng_nk1 = $NKX_fine
   wfng_nk2 = $NKY_fine
   wfng_nk3 = $NKZ_fine
   wfng_dk1 = 0.0
   wfng_dk2 = 0.0
   wfng_dk3 = 0.0
/
EOF
####----------------------####
#### Generate the k-grids ####
####----------------------####
echo "Generate the k-grids"
cd ./00-kgrid
$KGRID ./WFN_coarse.in ./WFN_coarse.out ./WFN_coarse.log
$KGRID ./WFN_fine.in ./WFN_fine.out ./WFN_fine.log
cd -
####-----------------------------####
#### Create ESPRESSO input files ####
####-----------------------------####
echo "Create ESPRESSO input files"
# scf
cat ./input_templates/espresso.inp > ./01-scf/in
cat ./00-kgrid/WFN_coarse.out >> ./01-scf/in
sed -i '/nbnd =/d' ./01-scf/in
# bs
cat ./input_templates/espresso.inp > ./03-bs/in
cat ./input_templates/bs_path.inp >> ./03-bs/in
sed -i "s/calculation = 'scf'/calculation = 'bands'/g" ./03-bs/in
# nscf
cat ./input_templates/espresso.inp > ./02-wfn/in
cat ./00-kgrid/WFN_coarse.out >> ./02-wfn/in
sed -i "s/calculation = 'scf'/calculation = 'nscf'/g" ./02-wfn/in
# nscf_fine
cat ./input_templates/espresso.inp > ./02-wfn_fine/in
cat ./00-kgrid/WFN_fine.out >> ./02-wfn_fine/in
sed -i "s/calculation = 'scf'/calculation = 'nscf'/g" ./02-wfn_fine/in
####-------------------------------####
#### Create input file for epsilon ####
####-------------------------------####
echo "Create input file for epsilon"
cat ./input_templates/epsilon.inp > ./07-epsilon/epsilon.inp
tail +4 00-kgrid/WFN_coarse.out | awk '{print $1 "  " $2 "  " $3 "  1.0  0"}' > ./tmp
NQPOINTS=`wc ./tmp | awk '{print $1}'`
echo "number_qpoints $NQPOINTS" >> ./07-epsilon/epsilon.inp
echo "begin qpoints" >> ./07-epsilon/epsilon.inp
cat ./tmp >> ./07-epsilon/epsilon.inp
echo "end" >> ./07-epsilon/epsilon.inp
rm ./tmp
####------------------------------------####
#### Create input file for epsilon_fine ####
####------------------------------------####
echo "Create input file for epsilon_fine"
cat ./input_templates/epsilon.inp > ./07-epsilon_fine/epsilon.inp
tail +4 00-kgrid/WFN_fine.out | head -1 | awk '{print $1 "  " $2 "  " $3 "  1.0  2"}' > ./tmp
echo "number_qpoints 1" >> ./07-epsilon_fine/epsilon.inp
echo "begin qpoints" >> ./07-epsilon_fine/epsilon.inp
cat ./tmp >> ./07-epsilon_fine/epsilon.inp
echo "end" >> ./07-epsilon_fine/epsilon.inp
rm ./tmp
