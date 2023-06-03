FROM fedora:latest

WORKDIR /root

RUN dnf -y update

RUN dnf -y install \
    python3 \
    python3-pip \
    nodejs \
    npm \
    net-tools \
    ca-certificates \
    curl \
    gnupg \
    procps \
    nano

COPY ./requirements.txt /tmp/requirements.txt

RUN python3 -m pip install -r /tmp/requirements.txt

RUN npm install -g configurable-http-proxy

RUN useradd -ms /bin/bash classroom

RUN mkdir -p /etc/ssl/private

RUN chown -R root:root /etc/ssl/private

RUN chmod -R u=rwX,go= /etc/ssl/private

COPY ./secrets/ssl.crt /etc/ssl/private/ssl.crt

COPY ./secrets/ssl.key /etc/ssl/private/ssl.key

RUN mkdir -p /srv/jupyterhub

COPY ./jupyterhub_config.py /etc/jupyterhub/jupyterhub_config.py

ARG CACHE_INVALIDATE

CMD jupyterhub -f /etc/jupyterhub/jupyterhub_config.py --debug 

# ENTRYPOINT ["tail", "-f", "/dev/null"]