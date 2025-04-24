#!/bin/bash -login
#SBATCH -A IRIS-IP005-CPU
#SBATCH --job-name="obsvista"
#SBATCH --time=01:00:00
#SBATCH --partition=icelake
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=3420mb

date

# ensure lsstinstall will add a scratch conda environment
noconda=$(which conda 2>&1|head -n 1|gawk '{print $2 $3}')

if [[ $noconda != noconda ]];
then
        echo "Please remove conda from PATH environment variable."
        exit 1
fi

# set tag
# for available tags, `ls $RDS/lsst_stack`
# if $tag is a weekly build, $_tag should be the version before that build
# note: $tag uses underscores as separators and $_tag uses dots.
tag=w_2025_13
_tag=28.0.2


# activate conda environment
source /rds/project/rds-rPTGgs6He74/lsst_stack/$tag/loadLSST.sh
# setup lsst_distrib

# change dir to EUPS packages path
cd $EUPS_PATH/Linux64

# ensurce clean install
if [[ -d obs_vista ]];
then
	rm -rf obs_vista
fi

# make and change to obs_vista dir
mkdir obs_vista
cd obs_vista

# Namespace
echo "Namespace: {tag:$tag, _tag:$_tag, PWD:$PWD, EUPS_PATH:$EUPS_PATH}"

# download obs_vista
git clone https://github.com/lsst-uk/obs_vista.git

# move to correct version tag using _tag syntax
mv obs_vista ${_tag}-1

# add obs_vista to eups package list
eups declare -t current obs_vista ${_tag}-1

# setup obs_vista
# instead of setup obs_vista, add obs_vista to lsst_distrib dependency table
sed -i.bak "/} else {/i \ \ \ setupRequired(obs_vista -j ${_tag}-1)" $EUPS_PATH/Linux64/lsst_distrib/*/ups/lsst_distrib.table
sed -i.bak "\$i \ \ \ setupRequired(obs_vista ${_tag}-1 [>= ${_tag}-1])" $EUPS_PATH/Linux64/lsst_distrib/*/ups/lsst_distrib.table

# setup lsst_distrib
setup lsst_distrib

# list packages for log
eups list

date
