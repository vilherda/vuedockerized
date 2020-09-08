#!/bin/bash

imagename=`whoami`/$(basename `pwd`)
version=`jq -r .version package.json`

basedir=`dirname $0`
filename=$(basename -- "$0")
extension="${filename##*.}"
filename="${filename%.*}"

cache='--no-cache'
cache=''

thetarget='production-stage'
extratag="-t ${imagename}:latest"
if [[ -n $1 && "dev" == "$1" ]]; then
  thetarget='develop-stage'
  extratag=''
  version='dev'
fi

docker build $cache -t ${imagename}:${version} $extratag --target $thetarget -f $basedir/${filename}.Dockerfile .

