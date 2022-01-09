#!/bin/bash
################################################################################
#                              Build Scrpit                                    #
#                                                                              #
#  Script created for demonstration purposes only, please do not use it.       #
#                                                                              #
#  2022 Miguel Almeida                                                         #
#                                                                              #
################################################################################
################################################################################
# Help                                                                         #
################################################################################
Help() {
    echo "Docker image builder"
    echo
    echo "Syntax: scriptTemplate [-b|t|p]"
    echo "options:"
    echo "  b     Build docker image from git rpository"
    echo "  t     Tag image"
    echo "  p     Push the docker image build to a docker image repository"
    echo
    echo "Example:"
    echo "alpima_setup.sh -b"
    echo "alpima_setup.sh -b -t alpima:dev"
    echo "alpima_setup.sh -b -t alpima:dev -p"
}
################################################################################
################################################################################
# Main                                                                         #
################################################################################

repo='https://github.com/myguel-ra/go-web-server.git'
branch='main'
tag=''
push=false
build=false
docker_repo=myguel/go-web-server

while getopts ':pbt:' flag; do
    case "${flag}" in
    p) push=true ;;
    b) build=true ;;
    t) tag="${OPTARG}" ;;
    :)
        echo "Error: -${OPTARG} requires an argument."
        exit 1
        ;;
    *)
        echo "Error: Unexpected option -${OPTARG}"
        exit 1
        ;;
    esac
done

if $build; then
    echo "Clone Repo"
    git clone $repo --depth 1 --branch $branch
    if [ -z $tag ]; then
        echo "Untagged Build"
        docker build .
    else
        echo "Tagged Build"
        docker build . -t $tag
    fi
    if $push; then
        echo "Pushing Image"
        echo $TOKEN | docker login -u $USER --password-stdin # Env variables
        docker push $docker_repo
        docker logout
    fi
    exit 0
fi

Help
