#!/usr/bin/env bash

source /etc/sysconfig/jenkins-slave

if [ ! -z "$MASTER_PORT_8080_TCP_ADDR" ]; then
  MASTER_URL="http://$MASTER_PORT_8080_TCP_ADDR:8080/"
fi

if [ -z "$NODE_EXECUTORS" ]; then
  NODE_EXECUTORS=1
fi

printf "\n****************************************\n\n"

printf "Master:    $MASTER_URL\n"
printf "Name:      $NODE_NAME\n"
printf "Label:     $NODE_LABEL\n"
printf "Executors: $NODE_EXECUTORS\n"

printf "\n\n****************************************\n"

su - $JENKINS_SLAVE_USER -c "$JAVA $JAVA_ARGS -jar $JENKINS_SLAVE_JAR \
  $JENKINS_SLAVE_ARGS -executors $NODE_EXECUTORS -master $MASTER_URL"
