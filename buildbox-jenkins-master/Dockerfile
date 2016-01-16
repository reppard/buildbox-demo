FROM jenkins:1.625.2

USER root

# Seed Jobs need bundler
RUN apt-get update \
  && apt-get install -y rubygems \
  && rm -rf /var/lib/apt/lists/* \
  && gem install bundler

# setup so Jenkins can access the host's docker socket
RUN groupadd -g 2001 -r docker && usermod -a -G docker jenkins

# we want jobs to use bash, not dash (which the official Jenkins image uses)
RUN ln -sf /bin/bash /bin/sh

# The place where to put the DSL files for the Seed Job to run
RUN mkdir -p /usr/share/jenkins/ref/jobs/SeedJob/workspace/

COPY plugins.txt /usr/share/jenkins/plugins.txt
COPY build/config.groovy /usr/share/jenkins/ref/init.groovy.d/config.groovy

RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

USER jenkins
