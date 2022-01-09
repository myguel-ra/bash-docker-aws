import requests
import sys
import boto3 # require pre-setup

# Author : XueWeiHan
# Date   : 2022
# Desc   : Script created for demonstration purposes only, please do not use it
#
# To set up and run this script, 
# you must first configure your AWS credentials, as described in
# https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html
#


# Get Page load time from arguments and show it
PageLoadTime = requests.get("http://" + sys.argv[1]).elapsed.total_seconds()
print(PageLoadTime)

# Create CloudWatch client
cloudwatch = boto3.client('cloudwatch')

# Put custom metrics
cloudwatch.put_metric_data(
    MetricData=[
        {
            'MetricName': 'PageLoad',
            'Dimensions': [
                {
                    'Name': 'TIME',
                    'Value': PageLoadTime
                },
            ],
            'Unit': 'None',
            'Value': 1.0
        },
    ],
    Namespace='SITE/TRAFFIC'
)

print("Published metric to AWS")
