#!/bin/bash
set -ex 

export AWS_PROFILE="daws25com"
export S3_BUCKET="s3://moontracer.daws25.com"

# copy template.yaml to s3 bucket with public read acl
aws s3 cp template.yaml $S3_BUCKET --acl public-read
echo done
