#!/bin/sh

mysqldump -h $1 --user=$2 --password=$3 $4 $5 --no-tablespaces --no-create-info

