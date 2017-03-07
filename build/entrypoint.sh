#!/bin/bash
# @package exadra37-dockerized/visual-studio-code
# @link    https://gitlab.com/u/exadra37-docker/visual-studio-code
# @since   2017/03/06
# @license MIT
# @author  Exadra37(Paulo Silva) <exadra37ingmailpointcom>
#
# Social Links:
# @link    Auhthor:  https://exadra37.com
# @link    Github:   https://gitlab.com/Exadra37
# @link    Github:   https://github.com/Exadra37
# @link    Linkedin: https://uk.linkedin.com/in/exadra37
# @link    Twitter:  https://twitter.com/Exadra37


printf "\nUpdate Installed Extensions From Docker Image...\n"

# Copy back all extensions installed by Docker build command, as per Dockerfile instructions.
# We need this trick because when the Container is started we map the Container .vscode dir to a Host one,
#  so that when the Container is removed, we don't loose any installed extensions during the use of Visual Studio Code.
cp -uR ~/.container/.vscode ~/.

printf "\nStarting Visual Studio Code...\n"

#sudo chsh -s /usr/bin/zsh

code -w
