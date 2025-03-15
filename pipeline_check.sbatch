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
tag=v28_0_0_rc2
vtag=$( echo $tag | tr -d v )
_tag=$( echo $vtag | tr _ . )

date
# Namespace
echo "Namespace: {tag:$tag, is_latest:$is_latest, PWD:$PWD, EUPS_PATH:$EUPS_PATH}"
# change to lsst_stack dir
cd /rds/project/rds-rPTGgs6He74/lsst_stack/
pipecheck_folder=${tag}_pipecheck
mkdir $pipecheck_folder
cd $pipecheck_folder
# activate the new conda environment
if source ../${tag}/loadLSST.sh
then
	# Download pipelines_check
	curl -L https://github.com/lsst/pipelines_check/archive/refs/tags/${_tag}.tar.gz | tar xvzf -
	cd pipelines_check-${_tag}
	
	# Run tests
	setup -r .
	./bin/run_demo.sh > ../../${tag}_pipecheck.log 2> ../../${tag}_pipecheck.err

	# Remove pipecheck
	cd ../..
	rm -rvf $pipecheck_folder
else
	echo "no ${tag} lsst_stack installed"
fi
date
