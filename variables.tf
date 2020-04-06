variable "jenkins_instance_type" {
  default = "t3.small"
}
variable "jenkins_ami_id" {
  default = "ami-0583e0c5ab79fbf99"
}
variable "start_schedule_expression" {
  default = "cron(0 7 ? * MON-FRI *)"
}
variable "stop_schedule_expression" {
  default = "cron(0 15 ? * MON-FRI *)"
}
variable "public_subnets" {
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  default = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}

variable "az" {
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}
