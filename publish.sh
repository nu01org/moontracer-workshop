#!/bin/bash
set -euo pipefail

export AWS_PROFILE="${AWS_PROFILE:-daws25com}"
export AWS_REGION="${AWS_REGION:-us-east-1}"
export BUCKET_NAME="${BUCKET_NAME:-workshops.daws25.com}"
export S3_BUCKET="s3://$BUCKET_NAME"

# check if bucket exists, create if not
if ! aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo "Bucket does not exist. Creating bucket: $BUCKET_NAME"

  CREATE_BUCKET_ARGS=(
    s3api create-bucket
    --bucket "$BUCKET_NAME"
    --acl public-read
    --object-ownership BucketOwnerPreferred
  )

  if [ "$AWS_REGION" != "us-east-1" ]; then
    CREATE_BUCKET_ARGS+=(--create-bucket-configuration "LocationConstraint=$AWS_REGION")
  fi

  aws "${CREATE_BUCKET_ARGS[@]}"
else
  echo "Bucket already exists: $BUCKET_NAME"
fi

# Ensure the bucket allows ACL-based public object uploads.
aws s3api put-bucket-ownership-controls \
  --bucket "$BUCKET_NAME" \
  --ownership-controls 'Rules=[{ObjectOwnership=BucketOwnerPreferred}]'

# Allow public object access on this bucket.
aws s3api put-public-access-block \
  --bucket "$BUCKET_NAME" \
  --public-access-block-configuration \
  BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false

# Copy template.yaml to the bucket with a public-read ACL.
aws s3 cp template.yaml "$S3_BUCKET" --acl public-read

echo done
