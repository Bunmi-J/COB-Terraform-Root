variable "aws_region" {
  default = "eu-north-1"
}

#variable "availability_zones" {
#  description = "Availability Zones to place the subnets in"
#  type        = list(string)
#  default = [
#    "eu-north-1a",
#    "eu-north-1b"
# ]
#}

variable "project_name" {
  type        = string
  description = "This is the project title"
  default     = "cob-root-project"
}

variable "environment" {
  description = "Environment name can be dev, staging or prod"
  default     = "dev"
}



variable "athena_user" {
  description = "List of IAM users that can access the Athena"
  type        = list(string)
}