#!/bin/bash
for JVM in openj9-jdk11 openj9-jre11 zing-11 ; do
    docker build -t leeyanzhe/jvm:$JVM --build-arg URL=$(cat $JVM.url) . ;
    docker push leeyanzhe/jvm:$JVM ;
    docker run -it --rm leeyanzhe/jvm:$JVM
done