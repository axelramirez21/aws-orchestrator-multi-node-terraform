### Establish Provider and Access ###
provider "aws" {
  profile    = "${var.profile}"
  region     = "${var.aws_region}"
}