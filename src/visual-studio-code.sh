#!/bin/bash
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
# Functions
########################################################################################################################

    function Create_Folder_If_Not_Exists()
    {
        local folder="${1}"

        [ -d "$folder" ] || mkdir -p "${folder}"
    }

    function Is_Not_Present_Docker_Image()
    {
        local image_name="${1}"

        [ -z $( sudo docker images -q "${image_name}" ) ] && return 0 || return 1
    }

    function Build_Docker_Image()
    {
        local image_name="${1}"

        local script_path="${2}"

        local git_user="${3}"

        local git_user_email="${4}"

        local uid=$( id -u )

        local gid=$( id -g )

        sudo docker build \
                --no-cache \
                --build-arg HOST_USER="${USER}" \
                --build-arg GIT_USER="${git_user}" \
                --build-arg GIT_USER_EMAIL="${git_user_email}" \
                --build-arg HOST_UID="${uid}" \
                --build-arg HOST_GID="${gid}" \
                -t "${image_name}" \
                "${script_path}"/../build
    }

    function Remove_Docker_Image()
    {
        local image_name="${1}"

        sudo docker rmi "${image_name}"
    }

    function Perform_Docker_Image_Action()
    {
        local image_action="${1}"

        local image_name="${2}"

        local script_path="${3}"

        local git_user="${4}"

        local git_user_email="${5}"

        if [ "rebuild" == "${image_action}" ]
            then
                Remove_Docker_Image "${image_name}"
        fi

        if Is_Not_Present_Docker_Image "${image_name}"
            then
                Build_Docker_Image "${image_name}" "${script_path}" "${git_user}" "${git_user_email}"
        fi
    }

    function Setup_X11_Server()
    {
        # Setup X11 server authentication
        # @link http://wiki.ros.org/docker/Tutorials/GUI#The_isolated_way
        local x11_authority="${1}"

        printf "\nSetup X11 Server...\n"

        touch "${x11_authority}" &&
        xauth nlist "${DISPLAY}" | sed -e 's/^..../ffff/' | xauth -f "${x11_authority}" nmerge -
    }

########################################################################################################################
# Variables Defaults
########################################################################################################################

    script_path=$(dirname $(readlink -f $0))

    profile='default'

    image_action=""

    host_developer_workspace="/home/${USER}/Developer"

    image_name="exadra37-dockerize/visual-studio-code"

    timestamp=$( date +"%s" )

    container_name="vscode${timestamp}"

    x11_socket=/tmp/.X11-unix

    git_user="Exadra37"

    git_user_email="exadra37@gmail.com"


########################################################################################################################
# Arguments
########################################################################################################################

    while getopts ':p:rw:h' flag; do
      case "${flag}" in
        p) profile="${OPTARG}" ;;
        r) image_action="rebuild" ;;
        w) host_developer_workspace="${OPTARG}" ;;
        h) cat "${script_path}"/../docs/help.txt; exit 0; ;;
        \?) printf "\noption -$OPTARG is not supported.\n"; exit 1 ;;
        :) printf "\noption -$OPTARG requires a value.\n"; exit 1 ;;
      esac
    done


########################################################################################################################
# Variables Assignments
########################################################################################################################

    host_vsc_dir=/home/"${USER}"/.dockerize/visual-studio-code/"${profile}"

    host_vsc_extensions_dir="${host_vsc_dir}"/.vscode

    host_vsc_config_dir="${host_vsc_dir}"/Code

    x11_authority="${host_vsc_dir}"/x11_authority

    shell_into_container="${2}"


########################################################################################################################
# Validations
########################################################################################################################

    Create_Folder_If_Not_Exists "${host_vsc_config_dir}"
    Create_Folder_If_Not_Exists "${host_vsc_extensions_dir}"


########################################################################################################################
# Execution
########################################################################################################################

    Perform_Docker_Image_Action "${image_action}" "${image_name}" "${script_path}" "${git_user}" "${git_user_email}"

    Setup_X11_Server "${x11_authority}"

    printf "\narg1: ${1}\n"
    printf "\narg2: ${2}\n"

    if [ "shell" == "${1}" ]
        then
           sudo docker exec \
                    --user="${USER}" \
                    -it \
                    "${shell_into_container}" \
                    zsh

            exit 0
    fi

    printf "\nTo Debug the Docker Container for Visual Studio Code Text:\n"
    printf "vscode shell ${container_name}\n\n"

    # Run Container with X11 authentication and using same user in container and host
    # @link http://wiki.ros.org/docker/Tutorials/GUI#The_isolated_way
    #
    # Additional to the above tutorial:
    #   * I set the container --workdir in the host to persist visual-studio-code settings and cache across restarts
    #   * I Also map my developer folder in the host to the container.
    #   * x11_socket and x11_authority only have ready access to the Host, instead of ready and write.
    printf "\nRun Visual Studio Code from a Docker Container...\n"
    sudo docker run \
            -it \
            --rm \
            --env="XAUTHORITY=${x11_authority}" \
            --env="DISPLAY" \
            --user="${USER}" \
            --name="${container_name}" \
            --volume="${host_vsc_config_dir}":/home/"${USER}"/.config/Code \
            --volume="${host_vsc_extensions_dir}":/home/"${USER}"/.vscode \
            --volume="$host_developer_workspace":/home/"${USER}"/developer \
            --volume="${x11_socket}":"${x11_socket}":ro \
            --volume="${x11_authority}":"${x11_authority}":ro \
            "${image_name}" \
            "./home/${USER}/.container/entrypoint.sh"

    printf "\n---> Visual Studio Code running from a Docker Container - by Exadra37 <---\n"
