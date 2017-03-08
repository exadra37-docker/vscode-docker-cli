#!/bin/bash
# @package exadra37-dockerized/visual-studio-code
# @link    https://gitlab.com/u/exadra37-docker/visual-studio-code
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

########################################################################################################################
# Sourcing
########################################################################################################################

    script_dir=$(dirname $(readlink -f $0))

    source "${script_dir}"/../vendor/exadra37-bash/docker-validator/src/functions/validate-images.func.sh
    source "${script_dir}"/../vendor/exadra37-bash/x11-server/src/functions/x11-server-authority.func.sh
    source "${script_dir}"/../vendor/exadra37-bash/dockerize-app/src/functions/docker-build.func.sh


########################################################################################################################
# Functions
########################################################################################################################


    function run()
    {
        printf "\nSetup X11 Server Authority...\n"

        Setup_X11_Server_Authority "${x11_authority_file}"

        printf "\nTo obtain a Shell inside the Docker Container:\n"
        printf "$ vscode shell ${container_name}\n"

        if Docker_Image_Does_Not_Exist "${image_name}"
            then
                build "${image_name}" "${build_context}"
        fi

        # Run Container with X11 authentication and using same user in container and host
        # @link http://wiki.ros.org/docker/Tutorials/GUI#The_isolated_way
        #
        # Additional to the above tutorial:
        #   * I set the container --workdir in the host to persist visual-studio-code settings and cache across restarts
        #   * I Also map my developer folder in the host to the container.
        #   * x11_socket and x11_authority_file only have ready access to the Host, instead of ready and write.
        printf "\nRun Visual Studio Code from a Docker Container...\n"

        printf "\nHOST DEVLOPER WORKSPACE: ${host_developer_workspace}\n"

        sudo docker run \
                -it \
                --rm \
                --env="XAUTHORITY=${x11_authority_file}" \
                --env="DISPLAY" \
                --user="${USER}" \
                --name="${container_name}" \
                --volume="${host_vsc_config_dir}":/home/"${USER}"/.config/Code \
                --volume="${host_vsc_extensions_dir}":/home/"${USER}"/.vscode \
                --volume="${host_developer_workspace}":/home/"${USER}"/Developer \
                --volume="${x11_socket}":"${x11_socket}":ro \
                --volume="${x11_authority_file}":"${x11_authority_file}":ro \
                "${image_name}" \
                "./home/${USER}/.container/entrypoint.sh" "${git_user}" "${git_user_email}"

        rm -rf "${x11_authority_file}"

    }

    function shell()
    {
        local shell_into_container="${1}"

        sudo docker exec \
                --user="${USER}" \
                -it \
                "${shell_into_container}" \
                zsh
    }

    function rebuild()
    {
        # local image_name="${2}"

        # local script_dir="${3}"

        # local git_user="${4}"

        # local git_user_email="${5}"

        sudo docker rmi "${image_name}"

        #build "${image_name}" "${script_dir}" "${git_user}" "${git_user_email}"
        build
    }

    function Create_Folder_If_Not_Exists()
    {
        local folder="${1}"

        [ -d "$folder" ] || mkdir -p "${folder}"
    }


########################################################################################################################
# Variables Defaults
########################################################################################################################

    script_dir=$(dirname $(readlink -f $0))

    profile='default'

    image_action=""

    host_developer_workspace="${PWD}"

    image_name="exadra37-dockerize/visual-studio-code"

    build_context="${script_dir}"/../build

    timestamp=$( date +"%s" )

    container_name="vscode${timestamp}"

    x11_socket=/tmp/.X11-unix

    git_user="Exadra37"

    git_user_email="exadra37@gmail.com"

    count_shifts=0


########################################################################################################################
# Arguments
########################################################################################################################

    while getopts ':p:w:h' flag; do
      case "${flag}" in
        p) profile="${OPTARG}"; ((count_shifts++))  ;;
        w) host_developer_workspace="${OPTARG}"; ((count_shifts++)) ;;
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
# Variables Assignments
########################################################################################################################

    host_vsc_dir=/home/"${USER}"/.dockerize/visual-studio-code/profiles/"${profile}"

    host_vsc_extensions_dir="${host_vsc_dir}"/.vscode

    host_vsc_config_dir="${host_vsc_dir}"/Code

    x11_authority_file="${host_vsc_dir}"/x11_authority_"${timestamp}"


########################################################################################################################
# Validations
########################################################################################################################

    Create_Folder_If_Not_Exists "${host_vsc_config_dir}"
    Create_Folder_If_Not_Exists "${host_vsc_extensions_dir}"


########################################################################################################################
# Execution
########################################################################################################################

    # vscode
    # vscode run

    if [ -z "${1}" ] || [ "run" == "${1}" ]
        then
            printf "\n---> Visual Studio Code running from a Docker Container - by Exadra37 <---\n"

            run

            exit 0
    fi

    # vscode build
    if [ "build" == "${1}" ]
        then
            build "${image_name}" "${build_context}"

            exit 0
    fi

    # vscode <options> <commands>
    "${@}"

