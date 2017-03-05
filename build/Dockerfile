#!/bin/bash
# @package exadra37-dockerize/visual-studio-code
# @link    https://gitlab.com/u/exadra37-dockerize/visual-studio-code
# @since   2017/03/05
# @license MIT
# @author  Exadra37(Paulo Silva) <exadra37ingmailpointcom>
#
# Social Links:
# @link    Auhthor:  https://exadra37.com
# @link    Github:   https://gitlab.com/Exadra37
# @link    Github:   https://github.com/Exadra37
# @link    Linkedin: https://uk.linkedin.com/in/exadra37
# @link    Twitter:  https://twitter.com/Exadra37

FROM ubuntu:latest

MAINTAINER Exadra37

ARG HOST_USER="${HOST_USER}"
ARG HOST_UID="${HOST_UID}"
ARG HOST_GID="${HOST_GID}"
ARG VSC_DEB_FILE="vsc.deb"

# Install Required Dependencies
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install \
        curl \
        sudo \
        libcanberra-gtk-module \
        libgconf-2-4 \
        libasound2 \
        libgtk2.0-0 \
        libxss1 && \
    apt-get -y -f install && \
    locale-gen en_GB.UTF-8 && \
    curl -L 'https://go.microsoft.com/fwlink/?LinkID=760868' -o "${VSC_DEB_FILE}" && \
    dpkg -i -R "${VSC_DEB_FILE}" || echo "\n Will force install of missing Visual Studio Code dependencies...\n" && \
    apt-get -y -f install && \
    useradd -m "${HOST_USER}" && \
    echo "${HOST_USER}:${HOST_USER}" | chpasswd && \
    usermod --shell /bin/bash "${HOST_USER}" && \
    usermod -aG sudo "${HOST_USER}" && \
    echo "${HOST_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/"${HOST_USER}" && \
    chmod 0440 /etc/sudoers.d/"${HOST_USER}" && \
    usermod  --uid "${HOST_UID}" "${HOST_USER}" && \
    groupmod --gid "${HOST_GID}" "${HOST_USER}" && \
    rm -rvf /var/lib/apt/lists/* && \
    rm -rvf "${VSC_DEB_FILE}"

ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:en
ENV LC_ALL en_GB.UTF-8

# Run Visual Studio Code
CMD ["/usr/bin/code", "-w"]
