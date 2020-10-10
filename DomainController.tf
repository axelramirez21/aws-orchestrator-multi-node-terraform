resource "aws_instance" "domain-controller" {
  ami           = data.aws_ami.server_ami.image_id
  instance_type = "t2.large"
  subnet_id     = aws_subnet.private[0].id
  
  vpc_security_group_ids = [
    aws_security_group.uipath_stack.id,
  ]
  
  associate_public_ip_address = false
  key_name                    = lookup(var.key_name, var.aws_region)

  user_data = data.template_file.bastion.rendered

  tags = {
    Name = "${var.application}-${var.environment}-DomainController"
    owner = var.owner_tag_name
  }
}

output "domain_controller_ip" {
  value = aws_instance.domain-controller.private_ip
}