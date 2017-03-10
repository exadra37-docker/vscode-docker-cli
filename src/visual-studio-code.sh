#!/bin/bash
# @package exadra37-dockerize/visual-studio-code
# @link    https://gitlab.com/u/exadra37-dockerize/visual-studio-code
# @since   2017/03/05
# @license GPL-3.0
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

    ebvsc_src_dir=$(dirname $(readlink -f $0))

    source "${ebvsc_src_dir}"/functions/vscode-run.func.sh
    source "${ebvsc_src_dir}"/functions/vscode-build.func.sh
    source "${ebvsc_src_dir}"/functions/vscode-rebuild.func.sh
    source "${ebvsc_src_dir}"/functions/vscode-shell.func.sh
    source "${ebvsc_src_dir}"/../vendor/exadra37-bash/pretty-print/src/functions/raw-color-print.func.sh


########################################################################################################################
# Variables Defaults
########################################################################################################################

    profile='default'

    host_developer_workspace="${PWD}"

    count_shifts=0


########################################################################################################################
# Arguments
########################################################################################################################

    while getopts ':p:w:h' flag; do
      case "${flag}" in
        p) profile="${OPTARG}"; count_shifts=$((${count_shifts} + 1)) ;;
        w) host_developer_workspace="${OPTARG}"; count_shifts=$((${count_shifts} + 1)) ;;
        h) cat "${ebvsc_src_dir}"/../docs/help.txt; exit 0; ;;
        \?) Print_Text_With_Label "Option -$OPTARG is not supported... See Help" "vscode -h" 41; exit 1 ;;
        :) Print_Text_With_Label "Option -$OPTARG requires a value... See Help" "vscode -h" 41; exit 1 ;;
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
            VSCode_Run "${profile}" "${host_developer_workspace}"

            exit 0
    fi

    # vscode build
    if [ "build" == "${1}" ]
        then
            VSCode_Build

            exit 0
    fi

    # vscode rebuild
    if [ "rebuild" == "${1}" ]
        then
            VSCode_Rebuild

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

            VSCode_Shell "${@}"

            exit 0
    fi

    Print_Text_With_Label "Whoops... Try help" "vscode -h" 41 # Red Label

    exit 1
