
resource "aws_security_group" "web" {
    name = "WebServersSecGroup"
    description = "Back-end web servers traffic"
    vpc_id  = "${aws_vpc.main.id}"

    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      security_groups = [ "${aws_security_group.lb.id}" ]
      cidr_blocks = ["${var.my_pub_IP}"]
    }

    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["${var.my_pub_IP}"]
    }

    # Allow HTTP to internet for yum etc.
    egress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow HTTPS to internet
    egress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
      Client  = "${var.client}"
      Name    = "${var.client}-Web-SecGroup"
    }
}

resource "aws_security_group" "lb" {
    name = "LoadBalancerSecGroup"
    description = "Traffic to and from load balancer"
    vpc_id  = "${aws_vpc.main.id}"

    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = [ var.vpc_ip_range ]
    }

    tags = {
      Client  = "${var.client}"
      Name    = "${var.client}-LB-SecGroup"
    }
}
