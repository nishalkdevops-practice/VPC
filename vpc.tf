resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  

  tags = {
    Name = "roboshop"
    Env = "DEV"
    Terraform = "true" 
    
  }
}


#subnets 

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "roboshop-public"
 
    
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "roboshop-private"

    
  }
}

#internet gateway 

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "roboshop-public-internetgateway"
  }
}


#public route table will have open/connect to an internet  

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }



  tags = {
    Name = "public_route_table-roboshop"
  }
}
 #private route table 


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id


 tags = {
    Name = "private_route_table-roboshop"
  }
}

#subnets assocaited with route tables (public subnet with public route and private subnet with private route table)


resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}


resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}





