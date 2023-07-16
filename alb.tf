# resource "aws_lb" "grad_proj_alb" {
#   name               = "grad-proj-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = ["${aws_security_group.alb_sg.id}", "${aws_security_group.grad_proj_sg["public"].id}"]
#   #subnets            = ["${aws_subnet.public.*.id}"]
#   subnets = [for i in range(0, length(data.aws_availability_zones.available.names), 1) : aws_subnet.public[i].id]
# }

# resource "aws_lb_target_group" "grad_proj_target_group_80" {
#   name     = "grad-proj-tg-80"
#   port     = 80  
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.my_vpc.id
# }

# resource "aws_lb_target_group" "grad_proj_target_group_5255" {
#   name     = "grad-proj-tg-5255"
#   port     = 5255  
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.my_vpc.id
# }

# resource "aws_lb_listener" "front_end" {
#   load_balancer_arn = aws_lb.grad_proj_alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.grad_proj_target_group_80.arn
#   }
# }

# resource "aws_lb_listener" "front_end_2" {
#   load_balancer_arn = aws_lb.grad_proj_alb.arn
#   port              = "5255"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.grad_proj_target_group_5255.arn
#   }
# }

# resource "aws_launch_template" "grad_proj" {
#   name = "grad-proj-launch-template"
#   #image_id = "${data.aws_ami.amzlinux2.id}"  
#   image_id = "${aws_ami_from_instance.example.id}"
#   instance_type          = "t2.micro"
#   key_name               = var.key
#   vpc_security_group_ids = [aws_security_group.grad_proj_sg["ssh"].id, aws_security_group.grad_proj_sg["http_https"].id, aws_security_group.target_group_sg.id, aws_security_group.grad_proj_sg["public"].id]
#   user_data              = filebase64("${path.module}/app1-install.sh")  # my-script.sh
# }

# resource "aws_autoscaling_group" "grad_proj" {
#   name = "grad-proj-autoscaling-group"
#   #desired_capacity    = 2
#   max_size            = 5
#   min_size            = 2
#   vpc_zone_identifier = [for i in range(0, length(data.aws_availability_zones.available.names), 1) : aws_subnet.public[i].id]
#   target_group_arns   = [aws_lb_target_group.grad_proj_target_group.arn , aws_lb_target_group.grad_proj_target_group_2.arn ]

#   launch_template {
#     id      = aws_launch_template.grad_proj.id
#     version = "$Latest"
#   }
# }

# resource "aws_autoscaling_policy" "grad_proj" {
#   name                   = "target-tracking-policy"
#   #scaling_adjustment     = 4
#   #cooldown               = 100  
#   policy_type = "TargetTrackingScaling"
#   adjustment_type        = "ChangeInCapacity"
#   autoscaling_group_name = "${aws_autoscaling_group.grad_proj.name}"
#   target_tracking_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ASGAverageCPUUtilization"
#     }
#     target_value = 50.0
#   }
# }


# #aws ec2 describe-instances --region us-east-2     --query 'Reservations[*].Instances[*].PublicIpAddress'     --output text


# # resource "aws_cloudwatch_metric_alarm" "grad_proj" {
# #   alarm_name          = "terraform-test-foobar5"
# #   comparison_operator = "LessThanOrEqualToThreshold"
# #   evaluation_periods  = "2"
# #   metric_name         = "CPUUtilization"
# #   namespace           = "AWS/EC2"
# #   period              = "60"
# #   statistic           = "Average"
# #   threshold           = "50"

# #   dimensions = {
# #     AutoScalingGroupName = "${aws_autoscaling_group.grad_proj.name}"
# #   }

# #   alarm_description = "This metric monitors ec2 cpu utilization"
# #   alarm_actions     = ["${aws_autoscaling_policy.grad_proj.arn}"]
# # }

# resource "aws_sns_topic" "grad_proj" {
#   name = "grad-proj-topic"
# }

# resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
#   topic_arn = aws_sns_topic.grad_proj.arn
#   protocol  = "email"
#   endpoint  = "ahmedkhalifa17@gmail.com"
# }

# resource "aws_autoscaling_notification" "example_notifications" {
#   group_names = [  "${aws_autoscaling_group.grad_proj.name}"  ]

#   notifications = [
#     "autoscaling:EC2_INSTANCE_LAUNCH",
#     "autoscaling:EC2_INSTANCE_TERMINATE",
#     "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
#     "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
#   ]

#   topic_arn = "${aws_sns_topic.grad_proj.arn}"
# }



# # resource "aws_sqs_queue" "user_updates_queue" {
# #   name = "user-updates-queue"
# # }

# # resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
# #   topic_arn = "${aws_sns_topic.user_updates.arn}"
# #   protocol  = "sqs"
# #   endpoint  = "${aws_sqs_queue.user_updates_queue.arn}"
# # }

# # data "aws_sns_topic" "example" {
# #   name = "test-2"
# # }

