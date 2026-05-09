FROM ghcr.io/rsl-org/fedora_p2996:latest

# code-server dependencies
RUN dnf install -y \
      curl \
      git \
      tar \
      gzip \
      vim \
      openssh-server

#RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
RUN tee /etc/yum.repos.d/vscode.repo <<EOF
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
autorefresh=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

RUN dnf install -y code

RUN useradd -m che -u 1001 -G wheel \
    && echo "che:" | chpasswd \
    && mkdir -p /home/che/projects /home/che/.config/code-server \
    && chown -R che:users /home/che

COPY authorized_keys /home/che/.ssh/authorized_keys
RUN chown che:users /home/che/.ssh/authorized_keys && \
    chmod 600 /home/che/.ssh/authorized_keys

COPY sshd_config /etc/ssh/sshd_config
RUN ssh-keygen -A

USER che
WORKDIR /home/che
