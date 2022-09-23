variable "account_id" {
  type        = string
  description = "The AWS account ID to deploy the infrastructure to."
  default     = "922911448091"
}

variable "team_name" {
  type        = string
  description = "The name of the team that owns the alerts"
  default     = "devops"
}

variable "file_name" {
  default = "lambda"
}

variable "function_path" {
  default = "lambda_slack"
}
