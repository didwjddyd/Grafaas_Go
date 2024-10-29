#! /bin/bash

echo $(pwd)
services='attackserver cc-db'

for service in $services
do
	# kubectl delete -f ${service}.yaml

	tag="jjhwan7099/${service}:latest"
	echo Building $tag
	(docker build --platform linux/amd64 -t $tag attackserver/${service}/.)
    docker push $tag
done

kubectl apply -f attackserver/attackserver.yaml
kubectl apply -f attackserver/cc-db.yaml