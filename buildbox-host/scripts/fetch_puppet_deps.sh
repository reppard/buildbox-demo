#!/usr/bin/env bash

set -ex

# Install Gem dependencies in a local cache
bundle install --path vendor/bundle

# Quick feedback on syntax/style erros
bundle exec puppet-lint puppet/manifests/site.pp

# Install Puppet module dependencies in a local cache
PUPPETFILE=puppet/Puppetfile \
  PUPPETFILE_DIR=puppet/modules \
  bundle exec r10k puppetfile check

PUPPETFILE=puppet/Puppetfile \
  PUPPETFILE_DIR=puppet/modules \
  bundle exec r10k puppetfile purge

PUPPETFILE=puppet/Puppetfile \
  PUPPETFILE_DIR=puppet/modules \
  bundle exec r10k puppetfile install -v
