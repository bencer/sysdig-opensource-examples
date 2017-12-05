#!/bin/sh

docker kill falco
docker rm falco
docker run -i -t --name falco --privileged \
-v /var/run/docker.sock:/host/var/run/docker.sock \
-v /dev:/host/dev \
-v /proc:/host/proc:ro \
-v /boot:/host/boot:ro \
-v /lib/modules:/host/lib/modules:ro \
-v /usr:/host/usr:ro \
-v $(pwd)/falco.yaml:/etc/falco.yaml \
-v $(pwd)/falco_rules.yaml:/etc/falco_rules.yaml \
-v $(pwd)/falco_rules.local.yaml:/etc/falco_rules.local.yaml \
-v $(pwd)/falco_events.log:/var/log/falco_events.log \
sysdig/falco
