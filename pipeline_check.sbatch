#!/bin/bash -login
#SBATCH -A IRIS-IP005-CPU
#SBATCH --job-name="lsstpipecheck"
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
_tag=$( echo $tag | tr _ . )

date
# change to lsst_stack dir
cd /rds/project/rds-rPTGgs6He74/lsst_stack/
mkdir ${tag}_pipecheck
cd ${tag}_pipecheck
# activate the new conda environment
source ../${tag}/loadLSST.sh

# Namespace
echo "Namespace: {tag:$tag, is_latest:$is_latest, PWD:$PWD, EUPS_PATH:$EUPS_PATH}"

# Download pipelines_check
https://github.com/lsst/pipelines_check/archive/refs/tags/w.2024.40.tar.gz
curl -L https://github.com/lsst/pipelines_check/archive/refs/tags/${_tag}.tar.gz | tar xvzf -
cd pipelines_check-${_tag}

# Run tests
setup -r .
./bin/run_demo.sh

date
