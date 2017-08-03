# FROM debian:jessie
# replace ^ with below for raspberry pi
FROM resin/rpi-raspbian:jessie

LABEL maintainer="brannon@brannondorsey.com"
LABEL license="MIT"

# python3.5 isn't in the default registry
RUN echo 'deb http://mirrordirector.raspbian.org/raspbian/ testing main contrib non-free rpi' > /etc/apt/sources.list.d/stretch.list 
RUN apt-get update --fix-missing && apt-get install -y \
    hostapd \
    dbus \
    net-tools \
    iptables \
    dnsmasq \
    net-tools \
    macchanger \
    software-properties-common \
    python3-software-properties \
    build-essential \
    python3-dev \
    python3-pip \
    libffi-dev \
    libssl-dev

RUN apt-get dist-upgrade --fix-missing
RUN apt-get autoremove

# install mitmproxy
RUN pip3 install mitmproxy

# mitmproxy requires this env
ENV LANG en_US.UTF-8 

# ADD mitmproxy/* /bin/
ADD hostapd.conf /etc/hostapd/hostapd.conf
ADD hostapd /etc/default/hostapd
ADD dnsmasq.conf /etc/dnsmasq.conf

ADD entrypoint.sh /root/entrypoint.sh
WORKDIR /root
ENTRYPOINT ["/root/entrypoint.sh"]
