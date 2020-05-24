docker run -it --rm --net host \
    -v /lib:/lib:ro \
    -v /lib64:/lib64:ro \
    -v /home/liyanzhe/code:/root \
    leeyanzhe/graalvm:ee-java11-scratch java -jar /root/stream-0.2.0-SNAPSHOT.jar

sudo docker run -it --rm --net host \
    -v /lib:/lib:ro \
    -v /lib64:/lib64:ro \
    -v /home/liyanzhe/code:/root \
    -v /home/liyanzhe/kafka-user-test:/tmp/kafka-user-test \
    leeyanzhe/graalvm:ee-java11-scratch \
    java \
        -Dspring.profiles.active=test \
        -server -Xms1g -Xmx1g \
        -XX:+UnlockExperimentalVMOptions \
        -XX:+EagerJVMCI \
        -XX:+UseAOT \
        -Dcom.sun.management.jmxremote.port=9999 \
        -Dcom.sun.management.jmxremote.authenticate=false \
        -Dcom.sun.management.jmxremote.ssl=false \
        -Dgraal.ShowConfiguration=verbose \
        -Dspring.datasource.url="jdbc:omnisci:omniscidb-server-headless.default:6274:deeparcher" \
        -Dspring.kafka.bootstrap-servers="kafka-kafka-bootstrap.default:9093" \
        -jar /root/stream-0.2.0-SNAPSHOT.jar

docker build -t leeyanzhe/jvm:zing-11 --build-arg URL=$(cat zing11.url) .
docker build -t leeyanzhe/jvm:openj9-jre11 --build-arg URL=$(cat openj9-jre11.url) .
https://trial-licenses.azul.com/redeem/56733393-4fb9-41f3-bd51-d66c20a7a4ef
wget -O- https://trial-licenses.azul.com/redeem/56733393-4fb9-41f3-bd51-d66c20a7a4ef > license.txt