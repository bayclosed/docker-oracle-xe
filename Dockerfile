FROM centos:centos7
# FORK https://github.com/madhead/docker-oracle-xe
MAINTAINER Gleb Kuzmenko <bayclosed@gmail.com>

# Pre-requirements
RUN mkdir -p /run/lock/subsys && \
    yum update -y && \
    yum install -y libaio bc initscripts net-tools && \
    yum install -y your_private_url/oracle-xe-11.2.0-1.0.x86_64.rpm && \
    yum clean all && \
    rm -f /var/tmp/yum-root-*/*.rpm

# Configure instance
ADD config/xe.rsp config/init.ora config/initXETemp.ora /u01/app/oracle/product/11.2.0/xe/config/scripts/
RUN chown oracle:dba /u01/app/oracle/product/11.2.0/xe/config/scripts/*.ora \
                     /u01/app/oracle/product/11.2.0/xe/config/scripts/xe.rsp
RUN chmod 755        /u01/app/oracle/product/11.2.0/xe/config/scripts/*.ora \
                     /u01/app/oracle/product/11.2.0/xe/config/scripts/xe.rsp
ENV ORACLE_HOME /u01/app/oracle/product/11.2.0/xe
ENV ORACLE_SID  XE
ENV PATH        $ORACLE_HOME/bin:$PATH

# Run script
ADD config/start.sh /
CMD /start.sh

# configure volume /oracle for data and diags
ADD config/oracle-xe.init /etc/init.d/oracle-xe
ADD config/XE.sh /u01/app/oracle/product/11.2.0/xe/config/scripts/XE.sh
VOLUME /oracle

EXPOSE 1521
EXPOSE 8080

# how to build
# docker build -t YourRegistry/oracle-xe .

# how to init
# docker run --rm -v /path/to/oracle/volume:/oracle YourRegistry/oracle-xe /etc/init.d/oracle-xe configure responseFile=/u01/app/oracle/product/11.2.0/xe/config/scripts/xe.rsp

# how to run
# docker run --name pythia -d -p 8089:8080 -p 1521:1521 -v /path/to/oracle/volume:/oracle YourRegistry/oracle-xe

# how to stop gracefully
# docker stop --time=30 pythia
# or
# docker kill -s TERM pythia

