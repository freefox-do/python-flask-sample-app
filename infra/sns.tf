resource "aws_sns_topic" "non_critical_topic" {
  name         = "NonCriticalAlertsDemo"
  display_name = "NonCriticalAlertsDemo"
}

resource "aws_sns_topic_subscription" "non_critical_topic_subscription_lambda" {
  depends_on = ["aws_lambda_function.alarms_slack_demo"]
  topic_arn  = "${aws_sns_topic.non_critical_topic.arn}"
  protocol   = "lambda"
  endpoint   = "${aws_lambda_function.alarms_slack_demo.arn}"
}
