resource "aws_db_subnet_group" "wordpress" {
  name       = "rds-private-subnet-group"
  subnet_ids = aws_subnet.databases.*.id

  tags = {
    Name = "My DB subnet group"
    owner = var.owner
  }
}

resource "aws_db_instance" "wordpress" {
  identifier = "db-wordpress"
  db_subnet_group_name   = aws_db_subnet_group.wordpress.id
  vpc_security_group_ids = [aws_security_group.allow_rds.id]
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = var.db_type
  name                   = var.db_name
  username               = var.db_user_name
  password               = var.db_pass
  parameter_group_name   = "default.mysql5.7"
  backup_retention_period= 3
  multi_az               = true
  skip_final_snapshot    = true
  final_snapshot_identifier = "whatever"
  tags = {
    Name = "My DB for wordpress"
    owner = var.owner
  }
}