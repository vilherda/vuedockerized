# vuedockerized

Vue environment based on Docker

## Requirements

To have a Docke environment installed and running correctly.

All the files __must be__ on the same directory and, _ideally_, on PATH.

Tool `jq` ust be present on PATH

## Contents

### `vueinithere.sh`

This script initializes a project based on Vue on the current directory.

It can be executed with an extra parameter: __`build`__. It will check for the last version of `@vue/cli` and will create, and update if already exists, the base image for the _normal_ execution of itself and to create the container of the application based on [Vue](https://vuejs.org) with the next script.

With a _normal_ execution it checks if this base image exists, otherwise, it will create it. The name of the image will be defined using the name of the current user as the context on local Docker repository.

### `vuecontainerize.sh`

This script creates the production image of the project using the base image created in the previous script. The name of the image will be defined also using the name of the current user as the context on local Docker repository. The version will be taken from file `package.json` and this image will be tagged as `latest` too. 

It can be executed with an extra parameter. The unique recognized value for this parameter is `dev`, so the created image will have `dev` as version value and can be used to build or test the Vue application as we will see on next script.

#### `vuerundockerized.Dockerfile`

It is the template used by the previous script to create the base image of the application based on Vue.

### `vuerundockerized.sh`

This script will execute the image associated to prodution environment (tagged as `latest`) created with the previous script.

It can be executed with an extra parameter, the version of the image that we want to execute, by example `dev` wich is available if it was created with the previous script, on this case the current directory will be mapped to the appication directory inside the container so it should (__must__) be the project directory. On this specific case, a session inside the container will be opened to make easy to use `vue` command.

An example of `dev` scenario:

```shell
$ > vuerundockerized.sh dev /bin/bash
root:hdsv83hdds8fd $ > npm run build
...
# next command will 'connect' the container environment with the host environment so you can access the UI
root:hdsv83hdds8fd $ > vue ui -H 0.0.0.0
```

## :copyright: License

[CC0-1.0 License](https://creativecommons.org/publicdomain/zero/1.0/legalcode)
