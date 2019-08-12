#!/usr/bin/env sh

PROJECT="installer"
VER=1.0.0

_exists() {
  cmd="$1"
  if [ -z "$cmd" ] ; then
    echo "Usage: _exists cmd"
    return 1
  fi
  if type command >/dev/null 2>&1 ; then
    command -v $cmd >/dev/null 2>&1
  else
    type $cmd >/dev/null 2>&1
  fi
  ret="$?"
  return $ret
}

version() {
  echo "$PROJECT"
  echo "v$VER"
}

showhelp() {
    version
}

_startswith() {
  _str="$1"
  _sub="$2"
  echo "$_str" | grep "^$_sub" >/dev/null 2>&1
}

_process() {
  _CMD=""
  while [ ${#} -gt 0 ]; do
    case "${1}" in

      --help | -h)
        showhelp
        return
        ;;
      --version | -v)
        version
        return
        ;;
      --install)

        _CMD="install"
        ;;
      memcached)

        curl http://debian.sb6.ru/install/{${1}} | sh

        _CMD="install"
        ;;
      *)
        echo "Unknown parameter : $1"
        return 1
        ;;
  esac
    shift 1
  done

  echo ${_CMD}

}



if _exists curl; then
  echo 1
else
  echo "Sorry, you must have curl or wget installed first."
fi

if [ "$INSTALLONLINE" ]; then
  INSTALLONLINE=""

  curl http://debian.sb6.ru/install/{${1}} > /usr/local/bin/i

  exit
fi

main() {
  [ -z "$1" ] && showhelp && return
#  if _startswith "$1" '-'; then _process "$@"; else "$@"; fi
  _process "$@"
}

main "$@"