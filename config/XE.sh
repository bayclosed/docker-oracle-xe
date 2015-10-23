#!/bin/sh

OLD_UMASK=`umask`
umask 0027
mkdir -p /u01/app/oracle/admin/XE/adump
mkdir -p /u01/app/oracle/admin/XE/dpdump
mkdir -p /u01/app/oracle/admin/XE/pfile
mkdir -p /u01/app/oracle/admin/cfgtoollogs/dbca/XE
mkdir -p /u01/app/oracle/admin/XE/dbs
mkdir -p /u01/app/oracle/fast_recovery_area
mkdir -p /u01/app/oracle/fast_recovery_area/XE
umask ${OLD_UMASK}
mkdir -p /u01/app/oracle/oradata/XE
ORACLE_SID=XE; export ORACLE_SID

for f in {diag,admin,fast_recovery_area,oradata} product/11.2.0/xe/{dbs,log,config/log,network/admin}
do mv /u01/app/oracle/$f /oracle/${f//\//_} && ln -s /oracle/${f//\//_} /u01/app/oracle/$f
done

/u01/app/oracle/product/11.2.0/xe/bin/sqlplus -s /nolog @/u01/app/oracle/product/11.2.0/xe/config/scripts/XE.sql

