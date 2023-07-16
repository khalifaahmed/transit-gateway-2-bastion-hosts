# output "the_loadbalancer_public_dns" {
#   value = aws_lb.grad_proj_alb.dns_name
# }
# output "the_pubic_ip" {
#   value = (var.ec2_count > 0) ? aws_instance.myec2[0].public_ip : ""
# }

# output "db_endpoint" {
#   value = var.db_instance ? aws_db_instance.grad_proj_db[0].endpoint : ""
# }
# output "db_endpoint_2" {
#   value = aws_db_instance.grad_proj_db[0].endpoint
#   precondition {
#     condition     = var.db_instance
#     error_message = "There is no database."
#   }
# }
# output "db_endpoint_3" {
#   depends_on = [ aws_db_instance.grad_proj_db ]
#   value = aws_db_instance.grad_proj_db[0].endpoint
# }