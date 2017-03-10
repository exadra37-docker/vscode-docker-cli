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

set -e

########################################################################################################################
# Sourcing
########################################################################################################################

    script_dir=$(dirname $(readlink -f $0))

    source "${script_dir}"/../vendor/exadra37-bash/dockerize-app/src/functions/docker-run.func.sh
    source "${script_dir}"/../vendor/exadra37-bash/dockerize-app/src/functions/docker-build.func.sh
    source "${script_dir}"/../vendor/exadra37-bash/pretty-print/src/functions/raw-color-print.func.sh
    source "${script_dir}"/../vendor/exadra37-bash/docker-container-shell/src/functions/shell.func.sh
    source "${script_dir}"/../vendor/exadra37-bash/folders-manipulator/src/functions/create-folder.func.sh


########################################################################################################################
# Functions
########################################################################################################################

    function run()
    {
        ### ARGUMENTS ###

            local docker_image="${1}"

            local build_context="${2}"

            local host_developer_workspace="${3}"

            local profile="${4}"


        ### ASSIGNMENTS ###

            local git_user="Exadra37"

            local git_user_email="exadra37@gmail.com"

            local host_vsc_dir=/home/"${USER}"/.dockerize/visual-studio-code/profiles/"${profile}"

            local host_vsc_extensions_dir="${host_vsc_dir}"/.vscode

            local host_vsc_config_dir="${host_vsc_dir}"/Code

            local command="./home/${USER}/.container/entrypoint.sh"

            local arguments="${git_user},${git_user_email}"

            local volumes="${host_vsc_config_dir}:/home/${USER}/.config/Code"
            local volumes="${volumes},${host_vsc_extensions_dir}:/home/${USER}/.vscode"
            local volumes="${volumes},${host_developer_workspace}:/home/${USER}/Developer"

        
        ### VALIDATIONS ###

            Create_Folder_If_Does_Not_Exist "${host_vsc_config_dir}"
            Create_Folder_If_Does_Not_Exist "${host_vsc_extensions_dir}"


        ### EXECUTION ###

            Print_Text "Visual Studio Code running from a Docker Container - by Exadra37"

            Print_Text "HOST DEVLOPER WORKSPACE: ${host_developer_workspace}" 97 # default white
        
            Docker_Run "${docker_image}" "${build_context}" "${volumes}" "${command}" "${arguments}" 
    }


########################################################################################################################
# Variables Defaults
########################################################################################################################

    profile='default'

    host_developer_workspace="${PWD}"

    docker_image="exadra37-dockerize/visual-studio-code"

    build_context="${script_dir}"/../build

    count_shifts=0


########################################################################################################################
# Arguments
########################################################################################################################

    while getopts ':p:w:h' flag; do
      case "${flag}" in
        p) profile="${OPTARG}"; count_shifts=$((${count_shifts} + 1)) ;;
        w) host_developer_workspace="${OPTARG}"; count_shifts=$((${count_shifts} + 1)) ;;
        h) cat "${script_dir}"/../docs/help.txt; exit 0; ;;
        \?) printf "\noption -$OPTARG is not supported.\n"; exit 1 ;;
        :) printf "\noption -$OPTARG requires a value.\n"; exit 1 ;;
      esac
    done

    while [ ${count_shifts} -gt 0 ]
        do
            shift
            shift
            ((count_shifts--))
    done


########################################################################################################################
# Execution
########################################################################################################################

    # vscode
    # vscode run
    if [ -z "${1}" ] || [ "run" == "${1}" ]
        then
            run "${docker_image}" "${build_context}" "${host_developer_workspace}" "${profile}"

            exit 0
    fi

    # vscode build
    if [ "build" == "${1}" ]
        then
            Docker_Build "${docker_image}" "${build_context}"

            exit 0
    fi

    # vscode rebuild
    if [ "rebuild" == "${1}" ]
        then
            Docker_Rebuild "${docker_image}" "${build_context}"

            exit 0
    fi

    # vscode shell <shell_into_container> [shell_name] [user]
    #
    # Examples:
    #   * vscode shell vscode1489000501
    #   * vscode shell vscode1489000501 zsh
    #   * vscode shell vscode1489000501 bash root
    if [ "shell" == "${1}" ]
        then
            shell_into_container=${2}

            shell_name=${3:-zsh}

            shell_user="${4:-$USER}"

            shell "${shell_into_container}" "${shell_name}" "${shell_user}"

            exit 0
    fi

    # vscode <options> <commands>
    "${@}"
