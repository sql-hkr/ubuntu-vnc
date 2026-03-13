FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=ubuntu
ENV PASSWORD=ubuntu

RUN apt-get update && apt-get install -y --no-install-recommends \
    lxde \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash $USER \
    && echo "$USER:$PASSWORD" | chpasswd \
    && usermod -aG sudo $USER

USER $USER
WORKDIR /home/$USER

EXPOSE 6080

CMD bash -c "\
    Xvfb :1 -screen 0 1280x800x24 & \
    export DISPLAY=:1 && \
    startlxde & \
    x11vnc -display :1 -nopw -forever -shared & \
    websockify --web=/usr/share/novnc/ 6080 localhost:5900 \
    "