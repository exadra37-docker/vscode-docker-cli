#!/bin/bash
# @package exadra37-dockerize/visual-studio-code
# @link    https://gitlab.com/u/exadra37-dockerize/visual-studio-code
# @since   5 March 2017
# @license GPL-3.0
# @author  Exadra37(Paulo Silva) <exadra37ingmailpointcom>
#
# Social Links:
# @link    Auhthor:  https://exadra37.com
# @link    Gitlab:   https://gitlab.com/Exadra37
# @link    Github:   https://github.com/Exadra37
# @link    Linkedin: https://uk.linkedin.com/in/exadra37
# @link    Twitter:  https://twitter.com/Exadra37


curl -L https://gitlab.com/exadra37-bash/bin-package-installer/raw/0.0.1.0/src/installer.sh | \
    bash -s -- -n exadra37-dockerize-vscode -p dockerize-vscode-cli  -t last-stable-release -s vscode:src/dockerize-vscode-cli.sh
