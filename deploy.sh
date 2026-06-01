#!/usr/bin/env bash
set -euo pipefail

STACK_NAME="moontracer-workshop-$RANDOM"
TEMPLATE_FILE="template.yaml"

if ! command -v aws >/dev/null 2>&1; then
  echo "Error: aws CLI not found. Install and configure AWS CLI before running this script." >&2
  exit 1
fi

echo "Deploying ${TEMPLATE_FILE} to CloudFormation stack ${STACK_NAME}."
aws cloudformation deploy \
  --stack-name "${STACK_NAME}" \
  --template-file "${TEMPLATE_FILE}" \
  --capabilities CAPABILITY_NAMED_IAM

echo "Deployment complete."

NOTEBOOK_URL=$(aws cloudformation describe-stacks \
  --stack-name "${STACK_NAME}" \
  --query "Stacks[0].Outputs[?OutputKey=='NotebookUrl'].OutputValue" \
  --output text)

echo "NotebookUrl: ${NOTEBOOK_URL}"
