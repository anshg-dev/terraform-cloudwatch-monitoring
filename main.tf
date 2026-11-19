terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Find latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 instance
resource "aws_instance" "monitoring_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  associate_public_ip_address = true

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name        = "Terraform-CloudWatch-Monitoring"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}

# CloudWatch CPU alarm
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "EC2-High-CPU-Alarm"
  alarm_description   = "Alarm when EC2 CPU utilization exceeds ${var.alarm_threshold}%"
  comparison_operator = "GreaterThanThreshold"

  evaluation_periods  = 2
  datapoints_to_alarm = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"

  period             = 60
  statistic          = "Average"
  threshold          = var.alarm_threshold
  alarm_actions      = []
  ok_actions         = []
  treat_missing_data = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.monitoring_server.id
  }

  tags = {
    Name      = "EC2-CPU-Alarm"
    ManagedBy = "Terraform"
  }
}
