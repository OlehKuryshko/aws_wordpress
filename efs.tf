resource "aws_efs_file_system" "wordpress" {
  creation_token = "efs-wordpress"
  encrypted = true
  lifecycle_policy {
    transition_to_ia = "AFTER_7_DAYS"
  }
  tags = {
    Name = "EFS for wordpress"
    owner = var.owner
  }
}
resource "aws_efs_mount_target" "wordpress" {
  file_system_id = aws_efs_file_system.wordpress.id
  count = length(aws_subnet.private.*.id)
  subnet_id = element(aws_subnet.private.*.id, count.index)
  security_groups = [aws_security_group.allow_nfs.id]
}

