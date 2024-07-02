# Installing LSST:UK environments on CSD3

First, ensure you are a member of the ip005 RDS Managers group (`rds-rPTGgs6He74-managers`).

Refer to [CSD3 Docs](https://docs.hpc.cam.ac.uk/hpc/).

Login to CSD3 via:

```shell
ssh -i ~/.ssh/<private key> <user>@login.hpc.cam.ac.uk
```

Add LSST:UK environment variables to your `.bashrc`:

```shell
cat $HOME/rds/rds-iris-ip005/lsst_env >> $HOME/.bashrc
exec $SHELL
```

Clone this repo (note: the repo is private, so you must have Github creds and be a member of the lsst-uk Organization):

HTTPS:
```shell
git clone https://github.com/lsst-uk/csd3_setup.git
```

or

SSH:
```shell
git clone git@github.com:lsst-uk/csd3_setup.git
```

## Install LSST Pipeline versions

Edit the following lines in `install_lsst_stack.sbatch`:

```shell
# set tag
# for available tags, see https://pipelines.lsst.io/install/lsstinstall.html#lsstinstall-other-tags
tag=v26_0_0
# set true if this is the latest vXX_X_X or w_XXXX_XX tag to be installed on CSD3
is_latest=false
```

so that `tag` is the tag you wish to install - either a `vXX_X_X` or a `w_XXXX_XX` tag. If this tag is the latest to be installed _on CSD3_, i.e., not necessarily the latest on [lsst.io]([url](https://pipelines.lsst.io)), set `is_latest` to `true`.

Run the installation via the SLURM scheduler:

```shell
sbatch install_lsst_stack.sbatch
```

This should take around 30-40 minutes.

The LSST Pipeline installations can be found under `$RDS/lsst_stack/<tag>`. If `is_latest` was set to `true`, `$RDS/lsst_stack/v_latest` or `$RDS/lsst_stack/w_latest` will link to the tag, depending on whether you installed a version or a weekly build.

## Install additional packages

### Install `obs_vista`

For full instructions on `obs_vista` installation, see [obs_vista](https://github.com/lsst-uk/obs_vista). These instructions have been adapted for the setup on CSD3 and added to [install_obs_vista.sbatch](install_obs_vista.sbatch).

To install, edit the following lines in `install_obs_vista.sbatch`:

```shell
# set tag
# for available tags, `ls $RDS/lsst_stack`
# if $tag is a weekly build, $_tag should be the version before that build
# note: $tag uses underscores as separators and $_tag uses dots.
tag=v26_0_0
_tag=26.0.0
```

so that `tag` is the LSST Pipeline tag into which you'd like to install `obs_vista` (this can be a version or a weekly build that exists in `$RDS/lsst_stack`) and `_tag` is the version separated by dots (for weekly builds this is the latest version before that build).

