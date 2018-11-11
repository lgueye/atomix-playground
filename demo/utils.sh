#!/usr/bin/env bash

function notify_result {
    if [ $? -eq 0 ]; then notify_success `echo ${@}`; else notify_failure `echo ${@}`; fi

}

function notify_success {
    echo `pwd`
    notify-send -i $(readlink -f ${1}/thumb_up.png) "`echo ${@:2}` succeeded"
}

function notify_failure {
    notify-send -i $(readlink -f ${1}/thumb_down.png) "`echo ${@:2}` failed"
}
