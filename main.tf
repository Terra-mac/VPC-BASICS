# create the VPC
resource "aws_vpc" "my-vpc" {
    cidr_block = "10.10.0.0/16"
    

    tags = {
        Name = "my_vpc"
        
    }
  
}

#crreate the subnet
resource "aws_subnet" "private_subnet"{
 vpc_id = aws_vpc.my-vpc.id
 cidr_block = "10.10.1.0/24"
 tags = {
   Name = "private_subnet"
 }
}

# create the public subnet
resource "aws_subnet" "public_subnet"{
 vpc_id = aws_vpc.my-vpc.id
 cidr_block = "10.10.2.0/24"
 tags = {
   Name = "public_subnet"
 }
}

# create the Internet gateway & attachment to vpc
resource "aws_internet_gateway" "my_igw" {
 vpc_id =   aws_vpc.my-vpc.id

 tags =  {
    Name = "my_igw"
 }
  
}

resource "aws_internet_gateway_attachment" "igw_attach" {
    internet_gateway_id = aws_internet_gateway.my_igw.id
    vpc_id =  aws_vpc.my-vpc.id


}

#create the route table
resource "aws_route_table" "public_rt" {
    vpc_id =  aws_vpc.my-vpc.id

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
}
  tags = {
    Name = "public_rt"
  }
}

# crate the route table association
resource "aws_route_table_association" "public_rt_table_association" {
    route_table_id = aws_route_table.public_rt.id
    subnet_id = aws_subnet.public_subnet.id
  
}
