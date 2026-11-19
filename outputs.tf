output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.monitoring_server.id
}

output "public_ip" {
  description = "EC2 public IP"
  value       = aws_instance.monitoring_server.public_ip
}

output "alarm_name" {
  description = "CloudWatch alarm name"
  value       = aws_cloudwatch_metric_alarm.cpu_alarm.alarm_name
}

output "alarm_threshold" {
  description = "CPU threshold"
  value       = aws_cloudwatch_metric_alarm.cpu_alarm.threshold
}

