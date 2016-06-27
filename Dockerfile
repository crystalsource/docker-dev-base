FROM ubuntu:14.04
MAINTAINER Mike Bertram <contact@crystalsource.de>

# Non interactive
ENV DEBIAN_FRONTEND noninteractive

# Install
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y --force-yes install supervisor openssh-server git vim curl

# SSHD
RUN mkdir -p /var/run/sshd /var/log/supervisor
RUN echo 'root:crystal' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Supervisor
ADD .docker/supervisor/ssh.conf /etc/supervisor/conf.d/supervisor-ssh.conf

# EXPOSE SSH
EXPOSE 22

# CMD
CMD ["supervisord", "-n"]