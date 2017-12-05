#!/bin/sh

export ARCH=amd64
export K8S_VERSION=v1.4.0

docker run -d \
--volume=/sys:/sys:rw \
--volume=/var/lib/docker/:/var/lib/docker:rw \
--volume=/var/lib/kubelet/:/var/lib/kubelet:rw,shared \
--volume=/var/run:/var/run:rw \
--net=host \
--pid=host \
--privileged \
gcr.io/google_containers/hyperkube-${ARCH}:${K8S_VERSION} \
/hyperkube kubelet \
--hostname-override=127.0.0.1 \
--api-servers=http://localhost:8080 \
--config=/etc/kubernetes/manifests \
--cluster-dns=10.0.0.10 \
--cluster-domain=cluster.local \
--allow-privileged --v=2
