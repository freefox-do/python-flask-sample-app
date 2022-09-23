import boto3
import boto3.session


size = 108
file_name = "upload_demo_file.zip"
aws_region = "ap-southeast-2"
owner = "Steve"


my_session = boto3.session.Session(region_name = aws_region, profile_name = "aws-devops")

client = my_session.client('cloudwatch')

client.put_metric_data(
        Namespace='FireZillaSample',
        MetricData=[
            {
                'MetricName': "FileUploadSize",
                'Value': size,
                'Dimensions': [
                    {
                        'Name': 'file_name',
                        'Value': file_name
                    },
                    {
                        'Name': 'aws_region',
                        'Value': aws_region
                    },
                    {
                        'Name': 'owner',
                        'Value': owner 
                    }
                ]
            }
        ])
