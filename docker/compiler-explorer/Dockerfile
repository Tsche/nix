FROM ghcr.io/rsl-org/fedora_p2996:latest
ENV PATH=/usr/local/bin:$PATH

RUN dnf -y install \
	--exclude=gcc* \
        --exclude=libstdc++* \
	git \
        curl \
        wget \
        tar \
        gzip \
        python3 \
        python3-pip \
        bzip2 \
        xz \
        unzip \
        jq \
        sudo \
        which \
	rsync \
	file \
        ca-certificates && \
    dnf clean all

RUN curl -fsSL https://rpm.nodesource.com/setup_22.x | bash - && \
    dnf install -y nodejs && \
    node -v && npm -v

RUN git clone https://github.com/compiler-explorer/compiler-explorer.git /opt/compiler-explorer && \
    cd /opt/compiler-explorer 

RUN cd /opt/compiler-explorer && npm i @sentry/node && make prebuild

EXPOSE 10240

WORKDIR /opt/compiler-explorer
ENTRYPOINT [ "make" ]
CMD ["run-only"]
