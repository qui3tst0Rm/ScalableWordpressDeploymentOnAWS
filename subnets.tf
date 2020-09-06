# create public subnets (currently set to create 3)
resource "aws_subnet" "public-snet" {
  vpc_id            = aws_vpc.wordpress_site.id
  count             = length(var.public-subnet-names)
  cidr_block        = var.list-pub-snet-cidr-blocks[count.index]
  availability_zone = var.availability-zone-eu-west-2-region[count.index]

  tags = {

    Name = var.public-subnet-names[count.index]
  }
  map_public_ip_on_launch = true
}

# create private subnets (currently set to create 3)
resource "aws_subnet" "private-snet" {
  vpc_id            = aws_vpc.wordpress_site.id
  count             = length(var.private-subnet-names)
  cidr_block        = var.list-pri-snet-cidr-blocks[count.index]
  availability_zone = var.availability-zone-eu-west-2-region[count.index]

  tags = {
    Name = var.private-subnet-names[count.index]
  }

}

resource "aws_db_subnet_group" "pri_db_snet_grp" {
  name       = "pri_db_snet_grp"
  subnet_ids = local.pri_snet_ids
  #subnet_ids = [aws_subnet.private-snet[0].id, aws_subnet.private-snet[1].id, aws_subnet.private-snet[2].id]
}