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
ARG GIT_USER="${GIT_USER}"
ARG GIT_USER_EMAIL="${GIT_USER_EMAIL}"

RUN apt-get update && \
    apt-get -y upgrade && \

    # Install Required Dependencies
    apt-get -y install \
        sudo \
        zsh \
        git \
        curl \
        php7.0 \
        python \
        python3 \
        libcanberra-gtk-module \
        libgconf-2-4 \
        libasound2 \
        libgtk2.0-0 \
        libxss1 && \

    # Force installation of missing dependencies
    apt-get -y -f install && \

    # Localization
    locale-gen en_GB.UTF-8 && \

    # Install Visual Studio Code
    curl -L 'https://go.microsoft.com/fwlink/?LinkID=760868' -o "${VSC_DEB_FILE}" && \
    dpkg -i -R "${VSC_DEB_FILE}" || echo "\n Will force install of missing Visual Studio Code dependencies...\n" && \

    # Force installation of missing dependencies for Visual Studio Code
    apt-get -y -f install && \

    # Add Host User in Container
    useradd -m "${HOST_USER}" && \
    echo "${HOST_USER}:${HOST_USER}" | chpasswd && \
    usermod --shell /usr/bin/zsh "${HOST_USER}" && \
    usermod -aG sudo "${HOST_USER}" && \
    echo "${HOST_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/"${HOST_USER}" && \
    chmod 0440 /etc/sudoers.d/"${HOST_USER}" && \
    usermod  --uid "${HOST_UID}" "${HOST_USER}" && \
    groupmod --gid "${HOST_GID}" "${HOST_USER}" && \

    # Setup Git
    su "${HOST_USER}" -c 'git config --global user.name "${GIT_USER}"' && \
    su "${HOST_USER}" -c 'git config --global user.email "${GIT_USER_EMAIL}"' && \

    # PHP 7 Profile
    su "${HOST_USER}" -c "printf 'Yes\n' | /usr/bin/code --install-extension felixfbecker.php-pack" && \

    # Python Profile
    su "${HOST_USER}" -c "/usr/bin/code --install-extension donjayamanne.python" && \

    # We need to copy .vscode dir because when Container is started, we use --volume to map this dir in the Container to
    #  another dir in the Host, so that we can persist all installed extensions after Container is removed.
    #
    # This allows us to reuse the installed extensions across all Containers we create, provided they are started
    #  with the same Profile.
    #
    # Now that we have a copy we can put it back when the container starts... see build/entrypoint.sh
    #
    # To Remember:
    #   * .vscode dir on the HOST will contain only the extensions installed by us during the use of Visual Studio Code.
    #   * .vscode dir in the DOCKER IMAGE contains only the extensions installed when build the Docker Image.
    #   * .vscode dir on the CONTAINER is a merge of the HOST dir with the DOCKER IMAGE dir during Container creation.
    su "${HOST_USER}" -c  'mkdir -p /home/"${HOST_USER}"/.container' && \
    su "${HOST_USER}" -c 'cp -R /home/"${HOST_USER}"/.vscode  /home/"${HOST_USER}"/.container/.vscode' && \

    # Install Oh My Zsh for Root
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
    chsh -s /usr/bin/zsh && \

    # Install Oh My Zsh for created $HOST_USER
    su "${HOST_USER}" -c 'bash -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"' && \
    chsh -s /usr/bin/zsh "${HOST_USER}" && \

    # cleaning
    rm -rvf /var/lib/apt/lists/* && \
    rm -rvf "${VSC_DEB_FILE}"

ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:en
ENV LC_ALL en_GB.UTF-8
ENV SHELL /usr/bin/zsh

COPY ./entrypoint.sh /home/"${HOST_USER}"/.container/entrypoint.sh

RUN chown -R "${HOST_USER}":"${HOST_USER}" /home/"${HOST_USER}"/.container
