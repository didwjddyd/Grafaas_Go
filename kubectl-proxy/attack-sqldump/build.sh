#! /bin/bash

services='attack-sqldump-product-purchase-authorize-cc attack-sqldump-product-purchase attack-sqldump-product-purchase-get-price attack-sqldump-product-purchase-publish' #attackserver cc-db''


for service in $services
do
	tag="jjhwan7099/${service}:latest"
	echo Building $tag
	(cp attackserver/cc-db/mitmproxy-ca-cert.pem attack-sqldump/${service}/. && docker build -t $tag attack-sqldump/${service}/.)
    docker push $tag
done

faas-cli up -f attack-sqldump/hello-retail.yaml
