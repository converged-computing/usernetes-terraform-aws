# Generate a packer build for an AMI (Amazon Image)

# This will allow us to use AWS plugins
packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}


# These variables can be referenced in our recipes below, and available
# on the command line of "packer build -var name=value"
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "instance_type" {
  type    = string
  default = "m4.large"
}

variable "key_file" {
  type    = string
  default = "dinosaur.pem"
}

# jammy in us-east-1
variable "source_ami" {
  type    = string
  default = "ami-06908478b0577ac8a"
}

# "timestamp" template function replacement for image naming
# This is so us of the future can remember when images were built
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# This is the packer recipe for the usernetes-compute ami
# Note that AWS credentials come from the environment and do not
# need to be provided directly here
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "amazon-ebs" "usernetes" {
  ami_name        = "packer-aws-usernetes-${local.timestamp}"
  ami_description = "An ubuntu base for usernetes intended to run on AWS EC2"
  instance_type   = "${var.instance_type}"
  region          = "${var.region}"
  ssh_username    = "${var.ssh_username}"
  ssh_interface   = "public_ip"
  #  ssh_keypair_name = "${var.key_file}"

  source_ami_filter {
    filters = {
      architecture                       = "x86_64"
      "block-device-mapping.volume-type" = "gp2"
      name                               = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type                   = "ebs"
      virtualization-type                = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"] // Canonical
  }
}

build {
  name    = "usernetes"
  sources = ["source.amazon-ebs.usernetes"]
  provisioner "shell" {
    scripts = ["./startup-script.sh"]
  }
}
