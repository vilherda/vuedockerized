#!/bin/bash

imagename=`whoami`/$(basename `pwd`)

if [[ -z $1 ]]; then
  version='latest'
else
  version=$1
  if [[ "dev" == "$version" ]]; then
    execmode='-it'
    volsmap="-v ${PWD}:/app"
  else
    execmode='-d'
    volsmap=''
  fi
fi
shift

externalport=8000
internalport=`docker inspect $imagename:$version | jq -r '.[0].ContainerConfig.ExposedPorts | keys | .[0]' | cut -d '/' -f 1`
portsmap="-p ${externalport}:${internalport}"

envvars=''

echo On a few seconds you can visit http://localhost:${externalport}

docker run --rm $execmode $portsmap $volsmap $envvars $imagename:$version $* 

