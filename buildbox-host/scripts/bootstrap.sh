#!/usr/bin/env bash
set -e

set -x

scripts/fetch_puppet_deps.sh

# Reboot and Reprovision the Vagrant box
vagrant destroy -f
vagrant up
