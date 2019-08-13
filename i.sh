#!/usr/bin/env sh

# install
# curl https://raw.githubusercontent.com/sb15/installer/master/i.sh | INSTALL=1 sh


PROJECT="installer"
PROJECT_FILES="https://raw.githubusercontent.com/sb15/installer/master/"
VER=1.0.0
BIN_FILE="/usr/local/bin/i"

_os() {
    OS=$(grep -oP '(?<=^ID=).+' /etc/os-release | tr -d '"')
}
_os

if [ "$(whoami)" != "root" ]; then
    SUDO=sudo
fi

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
      --install | --upgrade)
        _install
        ;;

      memcached | \
      nodejs-12 | \
      yarn | \
      php-7.2 | \
      php-7.2-phalcon | \
      composer | \
      postgresql | \
      elasticsearch-7 | \
      supervisord | \
      exim | \
      redis | \
      pack | \
      snapshot | \
      list )
        curl -fsS ${PROJECT_FILES}${OS}/{${1}} | sh
        ;;
      *)
        echo "Unknown parameter : $1"
        return 1
        ;;
  esac
    shift 1
  done
}

#HTTP_CODE=`curl http://example.com/ \
#      --verbose
#      --write-out "%{http_code}" \
#      --output my-output-file`
#
#if [ "$HTTP_CODE" != "200" ]; then
#    cat my-output-file
#    rm my-output-file
#fi

_install() {

  ${SUDO} apt-get -y install apt-transport-https lsb-release ca-certificates gnupg

  curl -fsS ${PROJECT_FILES}i.sh -o ${BIN_FILE}
  chmod 755 ${BIN_FILE}

  echo "installed to ${BIN_FILE}"
}

if [ "$INSTALL" ]; then
  INSTALL=""
  _install
  exit
fi

main() {
  [ -z "$1" ] && showhelp && return
#  if _startswith "$1" '-'; then _process "$@"; else "$@"; fi
  _process "$@"
}

main "$@"