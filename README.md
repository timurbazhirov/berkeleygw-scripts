BerkeleyGW_bandstructure_sh
==============================

Set of input templates and shell scripts to run an electronic bandstructure calculation with Quantum ESPRESSO and BerkeleyGW from scratch

You'll need:

    compiled Quantum EPRESSO's pw.x executable
    compiled BerkeleyGW's executables: epsilon, sigma and inteqp

Brief explanation on how to run:

Start with populating 

    ./input_templates/*

if you don't understand what's inside the *.inp files in this directory, please look into the corresponding input file description:

For ESPRESSO:

    http://www.quantum-espresso.org/wp-content/uploads/Doc/INPUT_PW.html

For Berkeley GW (as of Oct 24, 2013:)

    <BerkeleyGW source directory>/Epsilon/epsilon.inp
    <BerkeleyGW source directory>/Sigma/sigma.inp
    <BerkeleyGW source directory>/BSE/absorption.inp

then run 

    ./create_directories.sh
    ./create_input.sh
    ./create_links.sh
    ./create_input_sigma.sh

then submit calculation (edit the "./job" file modifying the input file paths and flags putting 'true-false' control flags)

    qsub ./job