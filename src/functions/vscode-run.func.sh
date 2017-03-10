#!/bin/bash
# @package exadra37-dockerize/visual-studio-code
# @link    https://gitlab.com/u/exadra37-dockerize/visual-studio-code
# @since   2017/03/10
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

    ebvsc_functions_dir=$(cd "$( dirname "${BASH_SOURCE}" )" && pwd )

    source "${ebvsc_functions_dir}"/vars/get-var-docker-image-name.func.sh
    source "${ebvsc_functions_dir}"/vars/get-var-docker-buid-context.func.sh
    source "${ebvsc_functions_dir}"/../../vendor/exadra37-bash/dockerize-app/src/functions/docker-run.func.sh
    source "${ebvsc_functions_dir}"/../../vendor/exadra37-bash/pretty-print/src/functions/raw-color-print.func.sh
    source "${ebvsc_functions_dir}"/../../vendor/exadra37-bash/folders-manipulator/src/functions/create-folder.func.sh


########################################################################################################################
# Functions
########################################################################################################################

    function VSCode_Run()
    {
        ### VARIABLES DEFAULTS ###

            local _docker_image_name; GET_VAR_DOCKER_IMAGE_NAME _docker_image_name

            local _docker_build_context GET_VAR_DOCKER_BUILD_CONTEXT _docker_build_context

            local _cli_name="vscode"

            local _git_user="Exadra37"

            local _git_user_email="exadra37@gmail.com"


        ### VARIABLES ARGUMENTS ###

            local _profile="${1}"

            local _host_developer_workspace="${2}"


        ### VARIABLES COMPOSITION ###

            local _host_vscode_dir=/home/"${USER}"/.dockerize/visual-studio-code/profiles/"${_profile}"

            local _host_vscode_extensions_dir="${_host_vscode_dir}"/.vscode

            local _host_vscode_config_dir="${_host_vscode_dir}"/Code

            local _command="./home/${USER}/.container/entrypoint.sh"

            local _arguments="${_git_user},${_git_user_email}"

            local _volumes="${_host_vscode_config_dir}:/home/${USER}/.config/Code"
            local _volumes="${_volumes},${_host_vscode_extensions_dir}:/home/${USER}/.vscode"
            local _volumes="${_volumes},${_host_developer_workspace}:/home/${USER}/Developer"


        ### VALIDATIONS ###

            Create_Folder_If_Does_Not_Exist "${_host_vscode_config_dir}"
            Create_Folder_If_Does_Not_Exist "${_host_vscode_extensions_dir}"


        ### EXECUTION ###

            Print_Text "Visual Studio Code running from a Docker Container - by Exadra37"

            Print_Text "HOST DEVLOPER WORKSPACE: ${_host_developer_workspace}" 97 # default white

            Docker_Run "${_docker_image_name}" "${_docker_build_context}" "${_cli_name}" "${_volumes}" "${_command}" "${_arguments}"

            Print_Text_With_Label "To Run With Another Profile" "vscode -p profile-name"

            Print_Text_With_Label "To Run With Another Workspace" "vscode -w /absolute/path/to/workspace"

            Print_Text_With_Label "To Rebuild Docker Image" "vscode rebuild" 101

            Print_Text_With_Label "To See Help" "vscode -h" 100
    }
