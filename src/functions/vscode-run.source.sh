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

    source "${ebvsc_functions_dir}"/vars/get-var-docker-image-name.source.sh
    source "${ebvsc_functions_dir}"/vars/get-var-docker-image-tag.source.sh
    source "${ebvsc_functions_dir}"/vars/get-var-docker-buid-context.source.sh
    source "${ebvsc_functions_dir}"/../../vendor/exadra37-bash/dockerize-app/src/functions/docker-run.source.sh
    source "${ebvsc_functions_dir}"/../../vendor/exadra37-bash/pretty-print/src/functions/raw-color-print.source.sh
    source "${ebvsc_functions_dir}"/../../vendor/exadra37-bash/folders-manipulator/src/functions/create-folder.source.sh


########################################################################################################################
# Functions
########################################################################################################################

    function VSCode_Run()
    {
        ### VARIABLES DEFAULTS ###

            local _docker_image_name; GET_VAR_DOCKER_IMAGE_NAME _docker_image_name

            local _docker_image_tag; GET_VAR_DOCKER_IMAGE_TAG _docker_image_tag

            local _docker_build_context; GET_VAR_DOCKER_BUILD_CONTEXT _docker_build_context

            local _container_user="${USER}"

            local _cli_name="vscode"

            local _git_user="Exadra37"

            local _git_user_email="exadra37@gmail.com"


        ### VARIABLES ARGUMENTS ###

            local _profile="${1}"

            local _host_developer_workspace="${2}"


        ### VARIABLES COMPOSITION ###

            local _host_vscode_dir=/home/"$USER"/.dockerize/visual-studio-code/"${_container_user}"/.profiles/"${_profile}"

            local _host_vscode_extensions_dir="${_host_vscode_dir}"/.vscode

            local _host_vscode_config_dir="${_host_vscode_dir}"/Code

            local _command="./home/${_container_user}/.container/vscode/entrypoint.sh"

            local _arguments="${_git_user} ${_git_user_email}"

            local _volumes="--volume=${_host_vscode_config_dir}:/home/${_container_user}/.config/Code"
            local _volumes="${_volumes} --volume=${_host_vscode_extensions_dir}:/home/${_container_user}/.vscode"
            local _volumes="${_volumes} --volume=${_host_developer_workspace}:/home/${_container_user}/Developer"


        ### VALIDATIONS ###

            Create_Folder_If_Does_Not_Exist "${_host_vscode_config_dir}"
            Create_Folder_If_Does_Not_Exist "${_host_vscode_extensions_dir}"


        ### EXECUTION ###

            Print_Text "Visual Studio Code running from a Docker Container - by Exadra37"

            Print_Text "HOST DEVLOPER WORKSPACE: ${_host_developer_workspace}" 97 # default white

            Docker_Run "${_docker_image_name}" "${_docker_image_tag}" "${_docker_build_context}" "${_cli_name}" "${_volumes}" "${_command}" "${_arguments}"

            Print_Text_With_Label "To Run With Another Profile" "vscode -p profile-name"

            Print_Text_With_Label "To Run With Another Workspace" "vscode -w /absolute/path/to/workspace"

            Print_Text_With_Label "To Rebuild Docker Image" "vscode rebuild" 101

            Print_Text_With_Label "To See Help" "vscode -h" 100
    }
