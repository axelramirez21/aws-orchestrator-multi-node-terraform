resource "aws_instance" "haa-master" {
  depends_on    = [aws_nat_gateway.main,aws_route_table_association.private_subnet_association]
  ami           = data.aws_ami.haa.image_id
  instance_type = "t2.large"
  subnet_id     = aws_subnet.private[0].id
  vpc_security_group_ids = [
    aws_security_group.uipath_stack.id,
  ]
  key_name                    = lookup(var.key_name, var.aws_region)

  user_data = data.template_file.haa-master.rendered

  tags = {
    Name = "${var.application}-${var.environment}-HAA-master"
    Owner = var.owner_tag_name
  }
}

output "haa_master_ip" {
  value = aws_instance.haa-master.private_ip
}

resource "aws_instance" "haa-slave" {
  depends_on = [aws_instance.haa-master]
  ami           = data.aws_ami.haa.image_id
  instance_type = "t2.large"
  subnet_id     = aws_subnet.private[0].id
  vpc_security_group_ids = [
    aws_security_group.uipath_stack.id,
  ]
  count = "2"
  key_name                    = lookup(var.key_name, var.aws_region)

  user_data = element(data.template_file.haa-slave.*.rendered, count.index)

  tags = {
    Name = "${var.application}-${var.environment}-HAA-slave"
    Owner = var.owner_tag_name
  }
}

output "haa_slave_ip" {
  value = aws_instance.haa-slave.*.private_ip
}