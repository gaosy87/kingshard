FROM ansible/centos7-ansible
MAINTAINER gao88 <fbg@live.com>

USER root

COPY ./resources/bin /usr/bin
COPY ./resources/conf /etc/

EXPOSE 9696 9797

CMD "kingshard"
