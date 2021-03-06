#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Missing API Key"
  exit 1
fi

read -r -d '' build_commands <<- EOM
  pip install --user conan_package_tools
  conan remote add bincrafters https://api.bintray.com/conan/bincrafters/public-conan
  conan remote add bincrafters https://api.bintray.com/conan/picoreti/is
  cd opencv && python build.py && cd ..
  cd SimpleAmqpClient && python build.py && cd ..
  cd prometheus-cpp && python build.py && cd ..
  cd opentracing-cpp && python build.py && cd ..
  cd is-msgs && python build.py && cd .. 
  cd is-wire && python build.py && cd .. 
  cd zipkin-cpp-opentracing && python build.py && cd ..
EOM

echo $build_commands

docker run -ti --rm --name=is_package_builder --network=host  \
  -e CONAN_UPLOAD=https://api.bintray.com/conan/picoreti/is   \
  -e CONAN_USERNAME=is                                        \
  -e CONAN_LOGIN_USERNAME=picoreti                            \
  -e CONAN_PASSWORD=$1                                        \
  -e CONAN_CHANNEL=stable                                     \
  -v `pwd`:/packages                                          \
  -w /packages                                                \
  lasote/conangcc54                                           \
  /bin/bash -c "$build_commands"