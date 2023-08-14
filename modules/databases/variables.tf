variable "identifier" {
  description = "VPC identifier"
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
  default     = "db.t3.small"
  type        = string
}

variable "postgres_version" {
  type        = string
  description = "The version of Postgres that terraform would create."
}