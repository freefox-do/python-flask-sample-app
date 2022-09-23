data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.function_path
  output_path = "${var.file_name}.zip"
}

resource "aws_lambda_function" "alarms_slack_demo" {
  filename         = "${var.file_name}.zip"
  function_name    = "alarms-slack-demo"
  description      = "DevOps Alarms"
  role             = "arn:aws:iam::${var.account_id}:role/LambdaRoleSlack"
  handler          = "notify-to-slack-channel.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "python3.6"
  timeout          = 300
}

resource "aws_lambda_permission" "with_sns_non_critical_topic" {
  statement_id  = "AllowExecutionFromSNS2"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.alarms_slack_demo.arn}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.non_critical_topic.arn}"
}
