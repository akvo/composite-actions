#!/bin/bash
set -eu

# ${1} for Server IP
# ${2} for Server Port
# ${3} for Server User
# ${4} for the command

server_ip="${1}"
server_port="${2}"
server_user="${3}"
command="${4}"

ssh -i priv.key -o BatchMode=yes \
    -p "${server_port}" \
    -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
    -o TCPKeepAlive=yes \
    -o ServerAliveInterval=10 \
    "${server_user}"@"${server_ip}" "cd src/ && ${command}"