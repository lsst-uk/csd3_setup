#!/bin/bash -login
#SBATCH -A IRIS-IP005-CPU
#SBATCH --job-name="lsststack"
#SBATCH --time=06:00:00
#SBATCH --partition=icelake
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=3420mb


# ensure lsstinstall will add a scratch conda environment
noconda=$(which conda 2>&1|head -n 1|gawk '{print $2 $3}')

if [[ $noconda != noconda ]];
then
        echo "Please remove conda from PATH environment variable."
        exit 1
fi

# set tag, e.g., v27_0_0 or w_2024_26
# for available tags, see https://pipelines.lsst.io/install/lsstinstall.html#lsstinstall-other-tags
tag=w_2024_40
# set true if this is the latest vXX_X_X or w_XXXX_XX tag to be installed on CSD3
is_latest=true

date
# change to lsst_stack dir
cd /rds/project/rds-rPTGgs6He74/lsst_stack/
# ensure clean install
rm -rf $tag
# download lsstinstall
curl -OL https://ls.st/lsstinstall
# make and change to dir for this build
mkdir $tag
cd $tag
# download and install this build
../lsstinstall -T $tag -p $PWD/conda -P
# activate the new conda environment
source loadLSST.sh

# Namespace
echo "Namespace: {tag:$tag, is_latest:$is_latest, PWD:$PWD, EUPS_PATH:$EUPS_PATH}"

# install lsst_distrib packages
eups distrib install -t $tag lsst_distrib
curl -sSL https://raw.githubusercontent.com/lsst/shebangtron/main/shebangtron | python
# setup lsst_distrib
# Not strictly necessary here, but a reminder that this needs to be run in every shell session.
setup lsst_distrib

# if this is the latest version to be installed,
# change v_latest or w_latest to point to this version
if [[ $is_latest == "true" ]];
then
        cd /rds/project/rds-rPTGgs6He74/lsst_stack
        if [[ $tag == v* ]];
        then
                rm v_latest
                ln -s $tag v_latest
        elif [[ $tag == w* ]];
        then
                rm w_latest
                ln -s $tag w_latest
        fi
fi
                

date
