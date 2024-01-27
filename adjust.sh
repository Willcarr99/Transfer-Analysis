#!/bin/sh

# For quickly adjusting parameters in xfresco and seeing how the results compare to a control run via a python plot.
# 1.) Run an initial Fresco calculation which you want to set as your control using
#     fresco < input_file.in > input_file.out
# 2.) Adjust settings in xfresco (faster) or input file itself and save changes
# 3.) Run ./adjust.sh

# This script creates temporary "control" fort files, removes all fort files, runs fresco with new input file, then runs the python comparison plot.
# Run in ~/Software/fresco-3.4/3He-Transfer

############################################
# Settings

# Excited state energy (keV), total spin of excited state (J), parity of excited state (pi), target + transfer particle bound state relative angular momentum (l)
# proton state node (n), and proton total angular momentum (j = l + s_p) (e.g. 1s_(1/2) ==> n=1, l=0, j=1/2 | 2d_(3/2) ==> n=2, l=2, j=3/2)
ex=8748
J=2
pi=-
l=3
n=2
j=7-2

# Change comparison_plots.py for fort.201 or fort.202
#fort=201
fort=202

#file=39K-3He-d-Transfer_40Ca${ex}keV_l${l}_n${n}_j${j}
file=39K-3He-d-Transfer_40Ca${ex}keV_Jpi${J}${pi}_l${l}_n${n}_j${j}_Global3He
#file=Cage_3Hed_1971_${ex}keV

#adjust_dir=/home/wcfox/Software/fresco-3.4/3He-Transfer
#adjust_dir="$(pwd)"
pdir=$(cd ../ && pwd)
#dest=${adjust_dir}/Input_Global3He/${ex}keV/Jpi${J}${pi}/l${l}/n${n}/j${j}
dest=${pdir}/Data/Input_Global3He/${ex}keV/Jpi${J}${pi}/l${l}/n${n}/j${j}
#dest=${adjust_dir}/BindingEnergy_Test/${ex}keV
#dest=${adjust_dir}/Input_Incorrect_Radius/${ex}keV/kind0/l${l}/n${n}/j${j} # Incorrect definition of radii for OMPs
#dest=${adjust_dir}/Input/${ex}keV/l${l}/n${n}/j${j}
#dest=${adjust_dir}/Papers/Cage1971/${ex}keV/l${l}/n${n}/j${j}
############################################

if [ ! -f "${dest}/${file}.in" ]; then
    echo "${dest}/${file}.in does not exist."
fi

if [ ! -f "${dest}/fort.${fort}" ]; then
    echo "${dest}/fort.${fort} does not exist."
fi

if [ ! -f "${dest}/fort.3" ]; then
    echo "${dest}/fort.3 does not exist."
fi

cp comparison_plots.py ${dest}/
cd ${dest}
cp fort.${fort} control_${fort}.txt
cp fort.3 control_3.txt
rm *fort*
fresco < ${file}.in > ${file}.out
python3 comparison_plots.py

