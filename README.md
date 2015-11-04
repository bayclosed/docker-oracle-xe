# Containerized Oracle XE 11g

It is a fork of https://github.com/madhead/docker-oracle-xe

What has changed:

1. Volume /oracle contains datafiles,FRA,spfile,logs,traces etc.
They are symlinked from /u01/app/oracle/... at startup

2. oracle-xe-11.2.0-1.0.x86_64.rpm is to be installed from a private URL so we avoid storing oracle-xe-11.2.0-1.0.x86_64.rpm in one of the layers.

## How to build

1. Download the [rpm installer](http://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html).
1. Unzip it and put `oracle-xe-11.2.0-1.0.x86_64.rpm` to your private http/ftp server
1. Edit Dockerfile and replace `**your_private_url/oracle-xe-11.2.0-1.0.x86_64.rpm**` with the URL from previous step
1. Run `docker build -t "YourRegistry/oracle-xe" .` from the root directory of this repo.
1. You should get your image ready in a few minutes (apart from downloading base `centos:centos7` image).

## How to use

# how to init
`docker run --rm -v /path/to/oracle/volume:/oracle YourRegistry/oracle-xe /etc/init.d/oracle-xe configure responseFile=/u01/app/oracle/product/11.2.0/xe/config/scripts/xe.rsp`

# how to run
`docker run --name pythia -d -p 8089:8080 -p 1521:1521 -v /path/to/oracle/volume:/oracle YourRegistry/oracle-xe`

# how to stop gracefully
`docker stop --time=30 pythia`
# or
`docker kill -s TERM pythia`

Oracle Web Management Console (apex) will be available at [http://localhost:8089/apex](http://localhost:8089/apex).
Use the following credentials to login:

    workspace: INTERNAL
    user: ADMIN
    password: oracle

Connect to the database using the following details:

    hostname: localhost
    port: 1521
    sid: XE
    username: system
    password: oracle

## Known issues

To build and use this image your host machine need to have at least 2GB of swap.
This is an Oracle XE limitation, described [here](http://docs.oracle.com/cd/E17781_01/install.112/e18802/toc.htm#XEINL106).
It is not possible to use `swapon` command from inside the container to increase swap space due to security reasons.
