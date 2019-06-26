
resource "aws_autoscaling_group" "asg" {
  name            = "${var.client}-ASG"
  vpc_zone_identifier = ["${aws_subnet.pub1.id}", "${aws_subnet.pub2.id}"]
  health_check_type = "ELB"
  max_size        = 5
  min_size        = 2
  desired_capacity = 3
  launch_configuration = "${aws_launch_configuration.lc.id}"
  health_check_grace_period = 300
  force_delete    = true
  wait_for_capacity_timeout = "10m"

  depends_on = [ "aws_alb.alb" ]
  target_group_arns = [ "${aws_alb_target_group.target-group-1.arn}" ]
}
