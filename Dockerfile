FROM wallacechendockerhub/rancher:release-v2-6-4
MAINTAINER "Wallace Chen"
EXPOSE 2225

# installation
RUN zypper refresh && zypper in --no-confirm openssh

# gen ssh hostkeys, there are placed in /etc/ssh folder
# sshd: no hostkeys available -- exiting.
RUN ssh-keygen -A

# ssh enable
RUN echo 'root:PmdjwEsUpfS8YAmD' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#Port 22/Port 2225/' /etc/ssh/sshd_config

# install rootfs
COPY ./rootfs.tar.gz /root/
RUN tar -xvf /root/rootfs.tar.gz -C / && rm -f /root/rootfs.tar.gz

# clean
RUN zypper -n clean -a && rm -rf /tmp/* /var/tmp/* /usr/share/doc/packages/*

ENTRYPOINT ["/usr/bin/entry"]
