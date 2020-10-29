resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [var.my_cidr]
  }
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]

  }
  tags = {
    Name = "allow_ssh"
    owner = var.owner
  }
}

resource "aws_security_group" "allow_rds" {
  name        = "allow_rds"
  description = "Allow mysql inbound traffic"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.my_cidr]

  }
  tags = {
    Name = "allow_rds"
    owner = var.owner
  }
}
resource "aws_security_group" "allow_nfs" {
  name        = "allow_nfs"
  description = "Allow EFS inbound traffic"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [var.my_cidr]

  
  }
  tags = {
    Name = "allow_nfs"
    owner = var.owner
  }
}
resource "aws_security_group" "web" {
  name = "allow_80"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.my_cidr]
  }
  tags = {
    Name = "allow_80"
    owner = var.owner
  }

}
resource "aws_security_group" "ssl" {
  name = "allow_443"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [var.my_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.my_cidr]
  }
  tags = {
    Name = "allow_443"
    owner = var.owner
  }
}