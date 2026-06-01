#!/usr/bin/env bash
set -euo pipefail

STACKS=$(aws cloudformation list-stacks \
  --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE ROLLBACK_COMPLETE \
  --query "StackSummaries[?starts_with(StackName, 'moontracer')].StackName" \
  --output text)

if [ -z "${STACKS}" ]; then
  echo "No moontracer stacks found."
  exit 0
fi

for STACK in ${STACKS}; do
  echo "Deleting stack: ${STACK}"
  aws cloudformation delete-stack --stack-name "${STACK}"
  aws cloudformation wait stack-delete-complete --stack-name "${STACK}"
  echo "Deleted: ${STACK}"
done
