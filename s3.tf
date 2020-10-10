#### S3 FileGateway Instance ####
#### This is really a gateway ###
resource "aws_instance" "gateway" {
  #ami           = "${data.aws_ami.gateway_ami.image_id}"
  
  #NEW IMAGE THAT WORKS WITH AWS 10/06/2020
  ami            = "ami-0056d3b3567a0b634"
  instance_type = "m4.xlarge"
  associate_public_ip_address = true
  # Refer to AWS File Gateway documentation for minimum system requirements.
  ebs_optimized = true
  subnet_id     = "${aws_subnet.public[0].id}"

  ebs_block_device {
    device_name           = "/dev/xvdf"
    volume_size           = "150"
    volume_type           = "gp2"
    delete_on_termination = true
  }

  key_name = "${lookup(var.key_name, var.aws_region)}"

  vpc_security_group_ids = [
    "${aws_security_group.uipath_stack.id}",
  ]

    tags  = {
            Name = "${var.application}-${var.environment}-FGW"
            owner = "${var.owner_tag_name}"
    }

}

resource "aws_storagegateway_gateway" "nfs_file_gateway" {
  gateway_ip_address = "${aws_instance.gateway.public_ip}"
  gateway_name       = "${var.application}-${var.environment}-GW"
  gateway_timezone   = "GMT"
  gateway_type       = "FILE_S3"
}

data "aws_storagegateway_local_disk" "cache" {
  disk_path   = "/dev/xvdf"
  #node_path  = "/dev/xvdf"
  gateway_arn = "${aws_storagegateway_gateway.nfs_file_gateway.id}"
}

resource "aws_storagegateway_cache" "nfs_cache_volume" {
  disk_id     = "${data.aws_storagegateway_local_disk.cache.id}"
  gateway_arn = "${aws_storagegateway_gateway.nfs_file_gateway.id}"
}

resource "aws_s3_bucket" "s3bucket_orchestrator" {
  bucket = "${var.s3BucketName}"
  acl    = "private"
  versioning {
    enabled = true
  }

}

resource "aws_storagegateway_nfs_file_share" "same_account" {
  client_list  = ["0.0.0.0/0"]
  gateway_arn  = "${aws_storagegateway_gateway.nfs_file_gateway.id}"
  location_arn = "${aws_s3_bucket.s3bucket_orchestrator.arn}"
  role_arn     = "${aws_iam_role.s3_tf_filegw.arn}"
}
