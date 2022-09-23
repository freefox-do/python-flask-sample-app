resource "aws_cloudwatch_metric_alarm" "upload_error" {
  alarm_name        = "firepizza file upload error"
  alarm_description = "Failed to upload file via firepizza"


  metric_name = "FileUploadStatus"
  namespace   = "FireZillaSample"
  period      = "120"

  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  statistic           = "Maximum"
  threshold           = "0"

  treat_missing_data = "breaching"

  alarm_actions = ["${aws_sns_topic.non_critical_topic.arn}"] 
  ok_actions    = ["${aws_sns_topic.non_critical_topic.arn}"] 
}
