provider "aws" {
  region  = "eu-west-1"
  profile = "terraform"
}
module "Scheduler" {
  source                    = "github.com/franusierra/terraform-scheduled-jenkins.git"
  START_SCHEDULE_EXPRESSION = var.start_schedule_expression
  STOP_SCHEDULE_EXPRESSION  = var.stop_schedule_expression
}
