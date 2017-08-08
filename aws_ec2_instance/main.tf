provider "aws" {
  profile = "${var.aws_profile}"
  region  = "${var.aws_region}"
}

provider "chef" {
  server_url   = "https://api.opscode.com/organizations/rrev/"
  client_name  = "${var.username}"
  key_material = "${file(pathexpand("~/.chef/${var.username}.pem"))}"
}

resource "aws_instance" "ec2_instance" {
  ami                         = "${data.aws_ami.invoca_encrypted.id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = ["${var.vpc_security_group_ids}"]
  subnet_id                   = "${var.subnet_id}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  count                       = "${var.count}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.root_volume_size}"
  }

  provisioner "chef" {
    environment     = "${var.environment}"
    run_list        = ["${var.chef_run_list}"]
    node_name       = "${var.environment}-${var.instance_name}-${count.index + 1}"
    secret_key      = "${file(pathexpand("~/.chef/launch_keys/app_staging_key"))}"
    server_url      = "https://api.opscode.com/organizations/rrev"
    recreate_client = true
    user_name       = "${var.username}"
    user_key        = "${file(pathexpand("~/.chef/${var.username}.pem"))}"
    version         = "${var.chef_version}"

    connection {
      type = "ssh"
      user = "ubuntu"
    }
  }
  
  tags {
    Name = "${var.environment}-${var.instance_name}-${count.index + 1}"
    Terraform = "true"
    Owner     = "${var.username}"
    run_list = "${join(",", var.chef_run_list)}"
  }

  lifecycle {
    ignore_changes = ["ami"]
  }

#  depends_on = ["chef_environment.env", "aws_instance.monitor"]
}

resource "chef_node" "node" {
  name = "${var.environment}-${var.instance_name}-${count.index + 1}"
  environment_name = "${var.environment}"
  lifecycle {
    ignore_changes = ["run_list"]
  }
}

resource "aws_route53_record" "public" {
  provider = "aws.prod"
  zone_id  = "${var.route53_zone}"
  name     = "${var.environment}-${var.instance_name}-${count.index + 1}.${var.domain_name}"
  type     = "A"
  ttl      = 300
  records  = ["${aws_instance.ec2_instance.public_ip}"]
}

resource "aws_route53_record" "internal" {
  provider = "aws.prod"
  zone_id  = "${var.route53_zone}"
  name     = "${var.environment}-${var.instance_name}-${count.index + 1}.internal.${var.domain_name}"
  type     = "A"
  ttl      = 300
  records  = ["${aws_instance.ec2_instance.private_ip}"]
}
