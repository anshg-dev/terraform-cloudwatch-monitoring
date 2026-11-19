variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "alarm_threshold" {
  description = "CPU utilization threshold percentage"
  type        = number
  default     = 70
}
