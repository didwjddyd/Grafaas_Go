#! /bin/bash

services='attack-helloworld-product-purchase-authorize-cc attack-helloworld-product-purchase attack-helloworld-product-purchase-get-price attack-helloworld-product-purchase-publish' 

for service in $services
do
	tag="jjhwan7099/${service}:latest"
	echo Building $tag
	(docker build -t $tag attack-helloworld/${service}/.)
    docker push $tag
done

faas-cli up -f attack-helloworld/hello-retail.yaml
