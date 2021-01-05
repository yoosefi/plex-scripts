#!/bin/bash

_getEmblems(){
    gio info -na metadata::emblems "$(realpath -s "${1}")" | awk 'match($0, "metadata::emblems: \\[(.+)\\]",m) { print m[1] }' | sed 's/,/ /g'
}

_setEmblems() {
    path="$(realpath -s "${1}")"
    [ -e "${path}" ] || return
    shift
    gio set -nt unset "${path}" metadata::emblems
    [ -n $1 ] && gio set -nt stringv "${path}" metadata::emblems "${@}"
    # poke inotify (refresh nemo) by touching without actually changing the mtime
    touch -r "${path}" "${path}"
}

addEmblem() {
    declare -A a
    for e in $(_getEmblems "${1}"); do a[$e]=$e; done
    a[$2]=$2;
    _setEmblems "${1}" "${a[@]}"
}

rmEmblem() {
    declare -A a
    for e in $(_getEmblems "${1}"); do a[$e]=$e; done
    unset a[$2]
    _setEmblems "${1}" "${a[@]}"
}

toIgnore() {
    # emulate python3 glob.escape()
    #        [[] [?] [*]
    pattern=$(sed 's/\(\[\|\?\|\*\)/[\1]/g' <<< "$(basename "${1}")")
    [ -d "${1}" ] && echo "${pattern}/*" || echo "${pattern}"
}
