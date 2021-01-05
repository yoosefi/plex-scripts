#!/bin/bash
source "$(dirname "${0}")/init.sh"

for x in "${@}"; do
    [ -d "${x}" ] || continue;
    case "$(basename "${0}")" in
        attention)
            addEmblem "${x}" $Attention
        ;;
        collection)
            addEmblem "${x}" $Collection
        ;;
        complete)
            addEmblem "${x}" $Complete
            rmEmblem "${x}" $Partial
            rmEmblem "${x}" $Missing
        ;;
        mostly-complete)
            rmEmblem "${x}" $Complete
            addEmblem "${x}" $Partial
            rmEmblem "${x}" $Missing
        ;;
        mostly-missing)
            rmEmblem "${x}" $Complete
            rmEmblem "${x}" $Partial
            addEmblem "${x}" $Missing
        ;;
        x-clear-x)
            _setEmblems "${x}" ""
        ;;
    esac
done

