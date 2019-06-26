resource "aws_alb" "alb" {
    name = "${var.client}-ALB"
    security_groups = [ "${aws_security_group.lb.id}" ]
    subnets = [ "${aws_subnet.pub1.id}", "${aws_subnet.pub2.id}" ]
}

resource "aws_alb_target_group" "target-group-1" {
  name = "target-group-1"
  port = 80
  protocol = "HTTP"
  vpc_id  = "${aws_vpc.main.id}"

  lifecycle { create_before_destroy=true }

  health_check {
    path = "/"
    port = 80
    healthy_threshold = 6
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200"
  }
}

resource "aws_alb_listener" "my-alb-listener" {
  default_action {
    target_group_arn = "${aws_alb_target_group.target-group-1.arn}"
    type = "forward"
  }
  load_balancer_arn = "${aws_alb.alb.arn}"
  port = 80
  protocol = "HTTP"
}

resource "aws_alb_listener_rule" "rule-1" {
  action {
    target_group_arn = "${aws_alb_target_group.target-group-1.arn}"
    type = "forward"
  }

  condition {
    field  = "path-pattern"
    values = ["/"]
  }

  listener_arn = "${aws_alb_listener.my-alb-listener.id}"
  priority = 100
}
