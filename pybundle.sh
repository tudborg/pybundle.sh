#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PY=${PY:-'python3'} # for the install command, and will be used as bundle shebang
ZIPPY=${ZIPPY:-'python3'} # python3 contains zipapp in stdlib

help () {
    echo "Usage:" >&2
    echo "  pybundle.sh build     <app_dir> [<executable_name> [<shebang>]]" >&2
    echo "  pybundle.sh install   <app_dir> [<pip_arguments>...]" >&2
    echo "  pybundle.sh patchmain <app_dir>" >&2
    echo "  pybundle.sh run       <app_dir>" >&2
}

patchmain () {
    [[ $# -gt 0 ]] || ( help && return 1 )
    local app_dir="$(realpath "$1")"
    local main="$app_dir/__main__.py"
    if grep '#---pybundle.sh---' "$main">/dev/null; then
        echo "already patched" >&2
        return 0
    fi
    local maindata="$(cat $main)"
    cat > "$main" <<"EOF"
#---pybundle.sh---
import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), 'site-packages'))
#---end---
EOF
    echo "$maindata" >> "$main"
}

bundle () {
    [[ $# -gt 0 ]] || ( help && return 1 )
    local app_dir="$(realpath "$1")"
    local exec_name="${2:-${app_dir}.pyz}"
    local shebang="${3:-"/usr/bin/env $PY"}"
    $ZIPPY -m zipapp --python "$shebang" --output "$exec_name" "$app_dir"
}

install () {
    [[ $# -gt 0 ]] || ( help && return 1 )
    local app_dir="$(realpath "$1")"
    shift
    # honestly, I have no idea why this works, but it does on osx
    # with a homebrew python which is normally broken AF.
    PYTHONPATH="$app_dir" $PY -m pip install --no-binary all --no-compile --prefix="$app_dir" "$@"
}

run () {
    [[ $# -gt 0 ]] || ( help && return 1 )
    local app_dir="$(realpath "$1")"
    shift
    local tmpexec="$(mktemp /tmp/pybundle.XXXXXX)"
    trap "rm \"$tmpexec\"" EXIT
    chmod +x "$tmpexec"
    bundle "$app_dir" "$tmpexec" && "$tmpexec" "$@"
}

main () {
    local cmd="$1" && shift
    case "$cmd" in
        patchmain)
            patchmain "$@"
            exit $?
            ;;
        build | bundle)
            bundle "$@"
            exit $?
            ;;
        install)
            install "$@"
            exit $?
            ;;
        run)
            run "$@"
            exit $?
            ;;
        *)
            help && exit 1
        ;;
    esac
}

main "$@"
