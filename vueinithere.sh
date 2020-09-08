#!/bin/bash

imagename=`whoami`/vue-cli

basedir=`dirname $0`
filename=$(basename -- "$0")
extension="${filename##*.}"
filename="${filename%.*}"

nodeimage='node:12.18.3-stretch'
exposedport=8000

function buildimage() {
  randomname=`dd if=/dev/urandom bs=1 count=8 | base64 | sed "s/\///g" | sed "s/\+//g" | sed "s/=//g"`
  tmpfullpath="${basedir}/${randomname}.Dockerfile"
  cat > $tmpfullpath <<- EOF
FROM $nodeimage
RUN npm install -g @vue/cli
EXPOSE $exposedport
EOF
  echo Temporary file generated: $tmpfullpath

  vuever=`npm search @vue/cli | grep -x "^@vue/cli .*" | cut -d "|" -f 5 | xargs`

  cache='--no-cache'
  cache=''

  docker build $cache -t ${imagename}:${vuever} -t ${imagename}:latest -f $tmpfullpath .

  rm -f $tmpfullpath
  echo Temporary file deleted: $tmpfullpath
}

if [[ -n $1 && "build" == "$1" ]]; then
  buildimage
else
  latestimage=`docker images ${imagename}:latest --format "{{.ID}}"`
  if [[ -z $latestimage ]]; then
    buildimage
  fi
  projname=$(basename `pwd`) && docker run --rm -v "`pwd`:/$projname" -w / -it $imagename sh -c "vue create --merge $projname"
fi

