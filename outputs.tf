output "mount-target-dns" {
  description = "Address of the mount target provisioned."
  value       = aws_efs_mount_target.wordpress.0.file_system_id
}

output "dns-db" {
  description = "Address of the dns name db instance"
  value       = aws_db_instance.wordpress.address
}

output "certificate-arn" {
  description = "certificate-arn"
  value       = aws_acm_certificate.myapp.arn
}