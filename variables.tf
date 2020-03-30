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
