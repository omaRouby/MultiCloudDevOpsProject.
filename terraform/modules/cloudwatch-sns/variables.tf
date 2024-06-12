variable "alarm_action_arn" {
  description = "The ARN of the SNS topic to trigger alarms"
}

variable "instance_id" {
  description = "The ID of the instance to monitor (for CloudWatch alarms)"
}

variable "sns_topic_name" {
  description = "The name of the SNS topic for CloudWatch notifications"
}

variable "email_endpoint" {
  description = "The email address to subscribe for SNS notifications"
}
