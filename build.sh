#! /bin/bash

PACKER=$(which packer)
[[ -z ${PACKER} ]] &&  echo 'packer command not found in the search path. exiting...' && exit 1

MEDIAWIKI_VERSION=1.30.0

${PACKER} build -var "region=${REGION}" -var "vpc_id=${VPC_ID}" -var "subnet_id=${SUBNET_ID}" -var "mediawiki_version=${MEDIAWIKI_VERSION}" -var "destination_regions=${DESTINATION_REGIONS}" build.json