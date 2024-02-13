#!/bin/sh

# For quickly adjusting parameters in xfresco and seeing how the results compare to a control run via a python plot.
# To create control files, type:
# cp fort.201 control_201.txt
# cp fort.3 control_3.txt

# This script removes all fort files, runs fresco with new input file, then runs the python comparison plot.
# Run in Transfer-Analysis/3He-ES directory

############################################
# Settings

#file=39K-3He3He-ES_Liang21MeV
#file=39K-3He3He-ES_Liang25MeV
#file=39K-3He3He-ES_Vernotte25MeV
file=39K-3He3He-ES_Liang21MeV_global
#adjust_dir="$(pwd)"
#pdir=$(cd ../ && pwd)
ppdir=$(cd ../../ && pwd) # parent of parent directory
dest=${ppdir}/Data/Input
#dest=${adjust_dir}/Input
############################################

fort_file=fort
control_file=control

if [ ! -f "${dest}/${file}.in" ]; then
    echo "${dest}/${file}.in does not exist."
fi

if [ ! -f "${dest}/${fort_file}.201" ]; then
    echo "${dest}/${fort_file}.201 does not exist."
fi

if [ ! -f "${dest}/${fort_file}.3" ]; then
    echo "${dest}/${fort_file}.3 does not exist."
fi

if [ ! -f "${dest}/${control_file}_201.txt" ]; then
    echo "${dest}/${control_file}_201.txt does not exist."
fi

if [ ! -f "${dest}/${control_file}_3.txt" ]; then
    echo "${dest}/${control_file}_3.txt does not exist."
fi

#rm *fort*
#fresco < ${file}.in > ${file}.out
#python3 comparison_plots.py

cp comparison_plots.py ${dest}/
cd ${dest}
cp fort.201 control_201.txt
cp fort.3 control_3.txt
rm *fort*
fresco < ${file}.in > ${file}.out
python3 comparison_plots.py

