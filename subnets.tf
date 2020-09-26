
# create public subnets (currently set to create 3)
resource "aws_subnet" "public-snet" {
  vpc_id            = aws_vpc.wordpress_site.id
  count             = length(var.pub-snet-names)
  cidr_block        = cidrsubnet(var.vpc-cidr-block[terraform.workspace], 3, count.index)
  availability_zone = var.az-eu-west-2-region[count.index]

  tags = {

    Name = var.pub-snet-names[count.index]
  }
  map_public_ip_on_launch = true
}

# create private subnets (currently set to create 3)
resource "aws_subnet" "private-snet" {
  vpc_id            = aws_vpc.wordpress_site.id
  count             = length(var.pri-snet-names)
  cidr_block        = cidrsubnet(var.vpc-cidr-block[terraform.workspace], 3, count.index + 3)
  availability_zone = var.az-eu-west-2-region[count.index]

  tags = {
    Name = var.pri-snet-names[count.index]
  }
}

# create db subnet group 
resource "aws_db_subnet_group" "pri_db_snet_grp" {
  name       = var.db-snetgp-name
  subnet_ids = aws_subnet.private-snet[*].id

}