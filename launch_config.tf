
resource "aws_launch_configuration" "lc" {
  name          = "${var.client}-web_config"
  image_id      = "ami-0cc96feef8c6bbff3"
  instance_type = "t3.nano"
  # This Key needs to already be present in the AWS account
  key_name      = "${var.client}KeyPair"
  security_groups = ["${aws_security_group.web.id}"]
  associate_public_ip_address = false

  user_data = <<-EOF
    #!/bin/bash

    yum update -y
    yum install -y python-pip git
    pip install flask
    pip install gunicorn

    mkdir -p /var/www/html/
    cd /var/www/html/
    git clone https://github.com/devsdd/HelloFlaskApp.git
    mkdir /var/log/gunicorn/
    cd HelloFlaskApp/
    gunicorn -b 0.0.0.0:80 --access-logfile /var/log/gunicorn/access_log --error-logfile /var/log/gunicorn/error_log wsgi
    echo 'cd /var/www/html/HelloFlaskApp/' >> /etc/rc.local
    echo 'gunicorn -b 0.0.0.0:80 --access-logfile /var/log/gunicorn/access_log --error-logfile /var/log/gunicorn/error_log wsgi' >> /etc/rc.local
    wget https://raw.githubusercontent.com/STH-Dev/linux-bench/master/linux-bench.sh && chmod +x linux-bench.sh
    EOF

  lifecycle {
    create_before_destroy = true
  }
}
