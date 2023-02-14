#!/bin/bash
set +e

CLEAR='\e[0m'
RED='\033[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[0;33m'
BLUE='\e[0;34m'

# assign default value, if the environment variables are empty
: "${TARGET_IMAGE:="wallacechendockerhub/rancher-builder:v1.0.0"}"
: "${RB_CONTAINER_NAME:="rancher-builder"}"
# The colon builtin (:) ensures the variable result is not executed.
# The double quotes (") prevent globbing and word splitting.


message() {
    echo "Please run:" >&2
    echo "            $0 build                  build rancher builder image.             " >&2
    echo "            $0 push                   push rancher builder image.              " >&2
    echo "            $0 run                    run rancher builder container.           " >&2
    echo "            $0 stop                   stop rancher builder container.          " >&2
}

build_rootfs() {
    tar -C ./rootfs/ -zcvf rootfs.tar.gz .
}

build_img() {
    build_rootfs;

    build_date=$(date +%Y%m%d%H%M%S)
    docker images --quiet --filter=dangling=true | xargs --no-run-if-empty docker rmi

    echo -e "${BLUE}building rancher builder image...${CLEAR}"

    docker build -t ${TARGET_IMAGE} . --no-cache -f Dockerfile
}

push_img() {
    echo -e "${BLUE}pushing rancher builder image...${CLEAR}"
    docker push ${TARGET_IMAGE}
}

run_rb() {
    echo -e "${BLUE}running ${RB_CONTAINER_NAME} container...${CLEAR}"
    docker run --name ${RB_CONTAINER_NAME} --net=host -v /var/run/docker.sock:/var/run/docker.sock --privileged=true -idt ${TARGET_IMAGE} bash
}

stop_rb() {
    echo -e "${BLUE}stopping ${RB_CONTAINER_NAME} container...${CLEAR}"
    docker stop ${RB_CONTAINER_NAME}
}

<<COMMENT
MULTILINE COMMAND
COMMENT

case "$1" in
    build)
        sleep 1
        if [ "$#" -ne 1 ]; then
            message;
            exit 1
        fi
        echo -e "${RED}⌛ $1${CLEAR}\n";
        build_img;
        exit 0
        ;;
    push)
        sleep 1
        if [ "$#" -ne 1 ]; then
            message;
            exit 1
        fi
        echo -e "${RED}⌛ $1${CLEAR}\n";
        push_img;
        exit 0
        ;;
    run)
        sleep 1
        if [ "$#" -ne 1 ]; then
            message;
            exit 1
        fi
        echo -e "${RED}👉 $1${CLEAR}\n";
        run_rb;
        exit 0
        ;;
    stop)
        sleep 1
        if [ "$#" -ne 1 ]; then
            message;
            exit 1
        fi
        echo -e "${RED}👉 $1${CLEAR}\n";
        stop_rb;
        exit 0
        ;;
    *)
        message;
        exit 1
        ;;
esac
exit 100