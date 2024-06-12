provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
}

module "security_groups" {
  source       = "./modules/security-groups"
  vpc_id       = module.vpc.vpc_id
  allowed_ports = [22, 80, 443, 8080, 9000]
}

module "ec2" {
  source         = "./modules/ec2"
  public_subnet  = module.vpc.public_subnet_id
  security_group = module.security_groups.sg_id
  key_name       = var.key_name
  ami_id         = var.ami_id
  instance_type  = var.instance_type
}

module "cloudwatch_sns" {
  source             = "./modules/cloudwatch-sns"
  alarm_action_arn   = var.alarm_action_arn
  instance_id        = module.ec2.instance_id
  sns_topic_name     = "CloudWatchNotifications"  # You can customize the SNS topic name here
  email_endpoint     = "omar.rouby2000@gmail.com"  # Replace with your email address
}
