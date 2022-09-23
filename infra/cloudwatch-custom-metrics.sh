#!/bin/bash

filesize=500
aws_region="ap-southeast-2"
file_name="cloudwatch-demo.zip"
owner="Steve"

aws --region "$aws_region" --profile "aws-devops" cloudwatch put-metric-data \
    --namespace "FireZillaSample" \
    --metric-name "FileUploadSize" \
    --value $filesize \
    --dimensions file_name="$file_name",aws_region="$aws_region",owner="$owner"
