##################################################################################
# VARIABLES
##################################################################################
aws_access_key = ""

aws_secret_key = ""



health_check_path = "/wp-admin/install.php"

project = "wordpress"

vpc-cidr-block = {
  Development = "10.0.0.0/20"
  Test        = "10.1.0.0/20"
  Prod        = "10.2.0.0/20"
}

instance_size = {
  Development = "t2.micro"
  Test        = "t2.micro" # "t2.small"
  Prod        = "t2.micro" # "t2.medium"
}

total_subnet_count = {
  Development = "6"
  Test        = "6"
  Prod        = "6"
}

public_subnet_count = {
  Development = "3"
  Test        = "3"
  Prod        = "3"
}

private_subnet_count = {
  Development = "3"
  Test        = "3"
  Prod        = "3"
}


az-eu-west-2-region = [
  "eu-west-2a",
  "eu-west-2b",
  "eu-west-2c"
]

/*instnace_count = {
  Development  = "3"
  Test = "3"
  Prod = "6"
}*/

vpc-name = {
  Development = "wp-vpc-Dev"
  Test        = "wp-vpc-test"
  Prod        = "wp-vpc-prod"
}

igw-name = {
  Development = "wp_vpc-igw-Dev"
  Test        = "wp_vpc-igw-test"
  Prod        = "wp_vpc-igw-prod"
}


inst-asg = {
  min-size         = "3"
  max-size         = "6"
  desired-capacity = "3"
}

pub-rtb-name = {
  Development = "dmz-rtb-dev"
  Test        = "dmz-rtb-test"
  Prod        = "dmz-rtb-prod"
}


pri-rtb-names = {
  Development = ["pri-rtb01-eu-west-2a-dev", "pri-rtb02-eu-west-2b-dev", "pri-rtb03-eu-west-2c-dev"]
  Test        = ["pri-rtb01-eu-west-2a-test", "pri-rtb02-eu-west-2b-test", "pri-rtb03-eu-west-2c-test"]
  Prod        = ["pri-rtb01-eu-west-2a-prod", "pri-rtb02-eu-west-2b-prod", "pri-rtb03-eu-west-2c-prod"]
}

lb-name = {
  Development = "wp-lb-dev"
  Test        = "wp-vpc-lb-test"
  Prod        = "wp-vpc-lb-prod"
}

nat-instance-names = [
  "nat01-pub-snet01-eu-west-2a",
  "nat02-pub-snet02-eu-west-2b",
  "nat03-pub-snet03-eu-west-2c"
]

pub-snet-names = [
  "pub-snet01-eu-west-2a-az",
  "pub-snet02-eu-west-2b-az",
  "pub-snet03-eu-west-2c-az"
]


pri-snet-names = [
  "pri-snet01-eu-west-2a-az",
  "pri-snet02-eu-west-2b-az",
  "pri-snet03-eu-west-2c-az"
]



/*nat-instance-names = {
    subnet0_id = "nat01-pub-snet-1-eu-west-2a"
    subnet1_id = "nat02-pub-snet-2-eu-west-2b"
    subnet2_id = "nat03-pub-snet-3-eu-west-2c"
}*/

/*protocols = {
  http = "HTTP"
}*/

/*from_Port = {

}*/

/*to_Port = {

}*/
##########################################################
#              MYSQL DB Instance Vars                    #
##########################################################

mysql = {
  allocated_storage = "20"
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t2.micro"
  #db-name           = 
  #db-username       = 
  #db-password       = 
  parameter_group_name = "default.mysql5.7"
}



