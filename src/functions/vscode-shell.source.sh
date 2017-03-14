#!/bin/bash
# @package exadra37-dockerize/visual-studio-code
# @link    https://gitlab.com/u/exadra37-dockerize/visual-studio-code
# @since   10 March 2017
# @license GPL-3.0
# @author  Exadra37(Paulo Silva) <exadra37ingmailpointcom>
#
# Social Links:
# @link    Auhthor:  https://exadra37.com
# @link    Gitlab:   https://gitlab.com/Exadra37
# @link    Github:   https://github.com/Exadra37
# @link    Linkedin: https://uk.linkedin.com/in/exadra37
# @link    Twitter:  https://twitter.com/Exadra37

set -e

########################################################################################################################
# Sourcing
########################################################################################################################

    ebvsc_functions_dir=$(cd "$( dirname "${BASH_SOURCE}" )" && pwd )

    source "${ebvsc_functions_dir}"/../../vendor/exadra37-bash/docker-exec/src/functions/docker-container-user-shell.source.sh


########################################################################################################################
# Functions
########################################################################################################################

    function VSCode_Shell()
    {
        local _shell_into_container=${2}

        local _shell_name=${3:-zsh}

        local _shell_user="${4:-$USER}"

        Docker_Container_User_Shell "${_shell_into_container}" "${_shell_name}" "${_shell_user}"
    }
