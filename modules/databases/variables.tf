variable "identifier" {
  description = "VPC identifierD"
  type        = string
}

variable "subnets" {
  description = "VPC subnets"
  type        = list(string)
}

variable "cluster_primary_security_group_id" {
  description = "VPC primary security group ID"
  type        = string
}

variable "rds_instance_class" {
  description = "RDS Instance class"
  default     = "db.t3.micro"
  type        = string
}
