#!/bin/bash
aws logs put-metric-filter \
--log-group-name post-log \
--filter-name ByContentSize \
--filter-pattern '[timestamp, size, user_id]' \
--metric-transformations \
'metricName=ByContentSize,metricNamespace=AppLog,metricValue=$size,defaultValue=0' --region ap-southeast-2
