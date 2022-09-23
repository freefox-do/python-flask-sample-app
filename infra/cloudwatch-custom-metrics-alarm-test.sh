#!/bin/bash

aws_region="ap-southeast-2"

aws --region "$aws_region" --profile "aws-devops" cloudwatch put-metric-data \
    --namespace "FireZillaSample" \
    --metric-name "FileUploadStatus" \
    --value 1
