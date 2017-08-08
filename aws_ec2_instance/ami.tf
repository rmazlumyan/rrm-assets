data "aws_ami" "invoca_encrypted" {
  most_recent = true

  filter {
    name   = "name"
    values = ["invoca/trusty-14.04/*/encrypted"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["self"]
}
