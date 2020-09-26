variable "aws_access_key" {}
variable "aws_secret_key" {}


variable "region" {
  default = "eu-west-2"
}

variable "vpc-cidr-block" {
  type = map(string)
}

variable "total_subnet_count" {
  type = map(string)
}

variable "public_subnet_count" {
  type = map(string)
}

variable "private_subnet_count" {
  type = map(string)
}

variable "az-eu-west-2-region" {
  type = list(string)
}

variable "instance_size" {
  type = map(string)
}

/*variable "instance_count" {
  type = map(string)
}*/

variable "vpc-name" {
  type = map(string)
}

variable "igw-name" {
  type = map(string)
}

variable "pub-snet-names" {
  type = list(string)
}

variable "pri-snet-names" {
  type = list(string)
}

variable "inst-asg" {
  type = map(string)
}

variable "pub-rtb-name" {
  type = map(string)
}

variable "pri-rtb-names" {
  type = map(list(string))
}

variable "lb-name" {
  type = map(string)
}

variable "nat-instance-names" {
  type = list(string)
}

variable "mysql" {
  type = map(string)
}

/*variable "mysql-secrets" {
  type = map(string)
}*/

variable "health_check_path" {}

variable "project" {}

variable "db-snetgp-name" {
  default = "db_snet_grp"
}

/*variable "protocols" {
  type = map(string)
}*/

/*variable "from_port" (
  type = map(string)
)*/

/*variable "to_port" (
  type = map(string)
)*/
