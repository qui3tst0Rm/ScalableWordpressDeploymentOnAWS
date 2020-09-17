# Europe (London) aws region
variable "region" {
  default = "eu-west-2"
}

##########################################################
#                       VPC Vars                         #
##########################################################

# vpc name
variable "vpc_name" {
  description = "name of the vpc"
  default     = "wordpress_site_vpc"
}

# list of availability zones within the eu-west-2 region
variable "availability-zone-eu-west-2-region" {
  description = "availability zones list"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

##########################################################
#               Internet Gateway Vars                    #
##########################################################

# internet gateway name
variable "wordpress-vpc-igw-name" {
  description = "name for the wordpress vpc inernet gateway"
  default     = "wordpress-vpc-igw"
}

##########################################################
#               CIDR BLOCK VARIABLES                     #
##########################################################
# cidr block for vpv
variable "vpc-cidr" {
  default     = "10.0.0.0/20"
  description = "cidr for the wordpress vpc"
}

# cidr blocks for public subnets
variable "list-pub-snet-cidr-blocks" {
  description = "list cidr for public subnets"
  type        = list(string)
  default     = ["10.0.0.0/23", "10.0.2.0/23", "10.0.4.0/23"]
}

# cidr block for private subnets
variable "list-pri-snet-cidr-blocks" {
  description = "list cidr for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/23", "10.0.12.0/23", "10.0.14.0/23"]
}

##########################################################
#              Auto Scaling Group Vars                   #
##########################################################
variable "asg-min-size" {
  default = 3
}

variable "asg-max-size" {
  default = 6
}

variable "desired-capacity" {
  default = 6
}

##########################################################
#              MYSQL DB Instance Vars                    #
##########################################################

variable "allocated_storage" {
  default = 20
}

variable "storage_type" {
  default = "gp2"
}

variable "engine" {
  default = "mysql"
}

variable "engine_version" {
  default = "5.7"
}

variable "instance_class" {
  default = "db.t2.micro"
}

variable "db-name" {
  default = "wpdbname"
}

variable "db-username" {
  default = "wordpress"
}

variable "db-password" {
  default = "Change_Me_w*njW#'@"
}

##########################################################
#                   NAME VARIABLES                       #
##########################################################
# public subnets names
variable "public-subnet-names" {
  description = "names for public subnets"
  type        = list(string)
  default     = ["pub-snet-1-eu-west-2a-az", "pub-snet-2-eu-west-2b-az", "pub-snet-3-eu-west-2c-az"]
}

# private subnets names
variable "private-subnet-names" {
  description = "names for private subnets"
  type        = list(string)
  default     = ["pri-snet-1-eu-west-2a-az", "pri-snet-2-eu-west-2b-az", "pri-snet-3-eu-west-2c-az"]
}

# public route table names
variable "public-rtb-names" {
  description = "public rtb names"
  #type        = list(string)
  default = "dmz-rtb"
  #default     = ["pub-rtb-1-eu-west-2a-az", "pub-rtb-2-eu-west-2b-az", "pub-rtb-3-eu-west-2c-az"]
}

# private route table names
variable "private-rtb-names" {
  description = "private rtb names"
  type        = list(string)
  default     = ["pri-rtb-1-eu-west-2a-az", "pri-rtb-2-eu-west-2b-az", "pri-rtb-3-eu-west-2c-az"]
}

# ALB Name
variable "lb_name" {
  description = "name of application lb"
  default     = "alb"
}

# nat instance names
variable "nat_instance_names" {
  description = "names for nat instances"
  type        = list(string)
  default     = ["nat01-pub-snet-1-eu-west-2a-az", "nat02-pub-snet-2-eu-west-2b-az", "nat03-pub-snet-3-eu-west-2c-az"]
}

# ec2 instance names for wp server
variable "ec2-instance-names" {
  description = "names for the ec2 instances used for wp site/app"
  type        = list(string)
  default     = ["web01-pri-snet1-eu-west-2a", "web02-pri-snet2-eu-west-2b", "web03-pri-snet3-eu-west-2c"]
}

/*variable "database_name" {
  description = "db server name"
  default     = "database-server"
}*/

##########################################################
#                       OTHERS                           #
##########################################################

# instance type
variable "instance_type" {
  description = "instance type"
  default     = "t2.micro"
}

# key name
variable "key_name" {
  default = "terraform5"
}

# key location
variable "private_key" {
  default = "~/.ssh/terraform5.pem"
}


variable "health_check_path" {
  description = "path for health check"
  default     = "/wp-admin/install.php"
}

