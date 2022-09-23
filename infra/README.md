# Steps 
1. When the Slack app is created, the next step is to activate incoming webhooks. This will enable us to post messages from external sources into our Slack workspace. After activating incoming webhooks, we then add a new webhook to the workspace by clicking the button at the bottom of the page. You will get a prompt in your slack channel once the integration is complete. Once the integration is successful, we copy the webhook URL at the bottom of the page and store it in a SSM parameter store as we proceed. Please refer to this [doc](https://medium.com/analytics-vidhya/generate-slack-notifications-for-aws-cloudwatch-alarms-e46b68540133)

2. Create a parameter in parameter store as `/devops/slack/slackwebhookurl`

3. Run `./cloudwatch-custom-metrics-alarm-test.sh` to trigger an alarm
