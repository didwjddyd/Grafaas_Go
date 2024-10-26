#! /bin/bash

services='attackserver cc-db'

for service in $services
do
	kubectl delete -f ${service}.yaml

	tag="jjhwan7099/${service}:latest"
	echo Building $tag
	(cd $service && docker build --platform linux/amd64 -t $tag .)
    docker push $tag
done

kubectl apply -f attackserver.yaml
kubectl apply -f cc-db.yaml