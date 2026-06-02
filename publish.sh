#!/bin/bash
set -ex 

export AWS_PROFILE="daws25com"
export BUCKET_NAME="workshops.daws25.com"
export S3_BUCKET="s3://$BUCKET_NAME"

# check if bucket exists, create if not
if ! aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo "Bucket does not exist. Creating bucket: $BUCKET_NAME"
  aws s3api create-bucket --bucket "$BUCKET_NAME"
else
  echo "Bucket already exists: $BUCKET_NAME"
fi

# copy template.yaml to s3 bucket with public read acl
aws s3 cp template.yaml $S3_BUCKET --acl public-read
echo done
