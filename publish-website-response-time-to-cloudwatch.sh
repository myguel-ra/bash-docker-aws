#!/bin/bash

PageLoadTime=$(curl www.google.com --compressed -s -o /dev/null -w  "%{time_starttransfer}\n")
echo "$PageLoadTime"

aws cloudwatch put-metric-data --metric-name PageLoadTime --namespace MyService --value "$PageLoadTime"
echo "Published metric to AWS"
