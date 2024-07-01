# Using [CSD3](https://docs.hpc.cam.ac.uk/hpc/) for LSST:UK work

See: [LSST:UK Confluence for more detail](https://lsst-uk.atlassian.net/wiki/spaces/LUSC/pages/3253436444/LSST+Pipeline+and+obs+vista+on+STFC+SCARF+and+Cambridge+CSD3)

## Request access through DiRAC SAFE

You can request access to the LSST:UK project (ip005) on CSD3 through DiRAC SAFE. Login is through SSH, and requires an SSH key and multi-factor authentication (MFA). Once setup, login via:

```shell
ssh -i ~/.ssh/<private key> <user>@login.hpc.cam.ac.uk
```

and enter your MFA Time-based One-Time Password (TOTP) from your authentication device (normally your smartphone).

Refer to [CSD3 Docs](https://docs.hpc.cam.ac.uk/hpc/) for more information.

Once logged onto CSD3 for the first time, it is useful to add some environment variables that have been setup to make LSST Pipeline activation easier:

```shell
cat $HOME/rds/rds-iris-ip005/lsst_env >> $HOME/.bashrc
exec $SHELL
```

Following this you’ll have environment variables for the shared storage space (`$RDS`) and for the latest versions and weekly builds of the LSST Pipeline (`$v_latest` and `$w_latest`, respectively). Note: this will be the latest version available on CSD3, not necessarily the latest version published by Rubin. Notes for admins to update the latest versions, see [ADMIN.md](ADMIN.md).

To activate the LSST Pipeline, use:

```shell
source $v_latest
```

or

```shell
source $w_latest
```

To see which versions these point to, you can do `ls -l $RDS/lsst_stack`, for example:

```shell
[<user>@login-q-1 lsst_stack]$ ls -l $RDS/lsst_stack
total 28
-rwxrwx---+ 1 <user> rds-iris-ip005 13033 Jun 28 13:48 lsstinstall
drwxrwx---+ 3 <user> iris-ip005      4096 Jun 28 13:27 v26_0_0
drwxrwx---+ 3 <user> iris-ip005      4096 Jun 28 14:16 v27_0_0
lrwxrwxrwx  1 <user> iris-ip005         7 Jul  1 09:34 v_latest -> v27_0_0
drwxrwx---+ 3 <user> iris-ip005      4096 Jun 28 14:03 w_2024_26
lrwxrwxrwx  1 <user> iris-ip005         9 Jun 28 13:27 w_latest -> w_2024_26
```

which shows `$v_latest` is `v27_0_0` and `$w_latest` is `w_2024_26`.

To activate a version other than the latest, use the path to its `loadLSST.sh` file, for example:

```shell
source $RDS/lsst_stack/v26_0_0/loadLSST.sh
```

will activate `v26_0_0`.

To find out about LSST Pipeline versions and weekly and daily builds, see [lsstinstall-other-tags](https://pipelines.lsst.io/install/lsstinstall.html#lsstinstall-other-tags).
