resource "aws_instance" "bastion" {
  ami               = var.ami
  instance_type     = var.instance_type
  availability_zone = var.availability_zone[0]
  key_name          = var.key_name
  network_interface {
    network_interface_id = aws_network_interface.bastion.id
    device_index         = 0
  }
  root_block_device {
    volume_size = "10"
}
  tags = {
    Name = "Bastion"
    owner = var.owner
  }
}
resource "null_resource" "bastion" {
  depends_on = ["aws_instance.bastion"]
  connection {
    host        = aws_instance.bastion.public_ip
    type        = "ssh"
    user        = var.user_bastion
    private_key = "${file(var.key)}"
  }
    provisioner "file" {
    source      = var.key
    destination = var.key_bastion
  }
}