
variable "region" {
  default = "us-east-1"
}

variable "aws_profile" {
  default = "ACME-aws-account"
}

variable "vpc_ip_range" {
  default = "192.168.0.0/23"
}

variable "pubnet1" {
  default = "192.168.0.0/24"
}

variable "pubnet2" {
  default = "192.168.1.0/24"
}

variable "client" {
  default = "ACME_corp"
}

variable "my_pub_IP" {
  default = "1.2.3.4/32"
}
