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
# Functions
########################################################################################################################

    function GET_VAR_DOCKER_IMAGE_TAG()
    {
        local __var_to_return__=${1?}

        local __docker_image_tag__='latest'

        eval $__var_to_return__="'${__docker_image_tag__}'"
    }
