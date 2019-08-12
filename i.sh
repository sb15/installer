#!/usr/bin/env sh

# install
# curl -fsS https://raw.githubusercontent.com/sb15/installer/master/i.sh | INSTALLONLINE=1 sh

PROJECT="installer"
OS="debian"
PROJECT_FILES="https://raw.githubusercontent.com/sb15/installer/master/"
VER=1.0.0

#/etc/os-release

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

        curl ${PROJECT_FILES}${OS}/{${1}} | sh

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

if [ "$INSTALLONLINE" ]; then
  INSTALLONLINE=""

  curl -fsS ${PROJECT_FILES}i.sh -o /usr/local/bin/i
  chmod 755 /usr/local/bin/i

  exit
fi

main() {
  [ -z "$1" ] && showhelp && return
#  if _startswith "$1" '-'; then _process "$@"; else "$@"; fi
  _process "$@"
}

main "$@"