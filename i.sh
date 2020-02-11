#!/usr/bin/env bash

# install
# sudo curl https://raw.githubusercontent.com/sb15/installer/master/i.sh | INSTALL=1 sh

PROJECT="Sb installer"
PROJECT_FILES="https://raw.githubusercontent.com/sb15/installer/master/"
VER=1.0.1
BIN_FILE="/usr/local/bin/i"
RED_COLOR='\033[0;31m'
GREEN_COLOR='\033[0;32m'
YELLOW_COLOR='\033[0;33m'
NC='\033[0m'

_os() {
    OS=$(grep -oP '(?<=^ID=).+' /etc/os-release | tr -d '"')
}
_os

_printf_red_text() {
 printf "${RED_COLOR}${1}${NC}"
}
_printf_green_text() {
 printf "${GREEN_COLOR}${1}${NC}"
}
_printf_yellow_text() {
 printf "${YELLOW_COLOR}${1}${NC}"
}

_string_exists() {
  case "${1}" in
  *${2}*)
    return 0
    ;;
  esac
  return 1
}

_service_info() {

  if _string_exists "${STATUS_ALL}" ${1}; then

    _printf_green_text "  ${1}";

    if _string_exists "${STATUS_ALL}" " + ]  ${1}"; then
      printf " running"
    fi

  else
    printf "  ${1}";
  fi

  printf "\n"
}

_package_info() {
  if [[ -z $(command -v ${1} 2>&1) ]]
  then
     printf "  ${1}";
  else
     _printf_green_text "  ${1}";
  fi

  printf "\n";
}

_exists() {
  cmd="$1"
  if [[ -z "$cmd" ]] ; then
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


showhelp() {

  STATUS_ALL=$(service --status-all 2>&1)

  version

  printf "\n"
  _printf_yellow_text "Usage:\n"
  printf "  i package\n"

  printf "\n"
  _printf_yellow_text "Options:\n"
  printf "  i --upgrade\n"
  printf "  i --help\n"

  printf "\n"
  _printf_yellow_text "Services:\n"
  _service_info "beanstalkd"
  _service_info "elasticsearch"
  _service_info "exim"
  _service_info "mysql"
  _service_info "memcached"
  _service_info "nginx"
  _service_info "openvpn"
  _service_info "php7.2-fpm"
  _service_info "php7.4-fpm"
  _service_info "postgresql"
  _service_info "redis"
  _service_info "supervisord"

  printf "\n"
  _printf_yellow_text "Packages:\n"
  _package_info "acme.sh"
  _package_info "git"
  _package_info "composer"
  _package_info "nodejs"
  _package_info "pack"
  _package_info "unpack"
  _package_info "phpcs"
  _package_info "phpmd"
  _package_info "phpstan"
  _package_info "phpunit"
  _package_info "yarn"

}

version() {
  printf "${PROJECT} ${VER}\n"
}

_process() {
  _CMD=""
  while [[ ${#} -gt 0 ]]; do
    case "${1}" in

      --help | -h)
        showhelp
        return
        ;;
      --version | -v)
        showhelp
        return
        ;;
      --install | --upgrade)
        _install
        ;;

      acme.sh | \
      beanstalk | \
      composer | \
      elasticsearch-7 | \
      exim | \
      git | \
      mariadb | \
      memcached | \
      nginx | \
      nodejs-12 | \
      openvpn | \
      pack | \
      php-7.2 | \
      php-7.2-phalcon | \
      phpcs | \
      phpmd | \
      phpstan | \
      phpunit | \
      postgresql | \
      redis | \
      snapshot | \
      supervisor | \
      yarn )
        curl -fsS ${PROJECT_FILES}${OS}/{${1}} | sh
        ;;
      *)
        echo "Command not found: ${1}"
        showhelp
        return
        ;;
  esac
    shift 1
  done
}

_install() {

  sudo apt-get -y install apt-transport-https lsb-release ca-certificates gnupg

  sudo curl -fsS ${PROJECT_FILES}i.sh -o ${BIN_FILE}
  sudo chmod 755 ${BIN_FILE}

  printf "installed to ${BIN_FILE}\n"
  printf "add to bash.rc\n"
  printf "complete -W 'acme.sh beanstalk composer elasticsearch-7 exim git mariadb memcached nginx nodejs-12 openvpn pack php-7.2 php-7.2-phalcon phpcs phpmd phpstan phpunit postgresql redis snapshot supervisor yarn'\n"
}

if [[ "${INSTALL}" ]]; then
  INSTALL=""
  _install
  exit
fi

main() {
  [[ -z "${1}" ]] && showhelp && return
  _process "$@"
}

main "$@"