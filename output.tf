output "db-endpoint" {
  value = aws_db_instance.wordpress_db.endpoint
}

output "db-address" {
  value = aws_db_instance.wordpress_db.address
}

output "alb-id" {
  value = aws_lb.wordpress_alb.id
}

output "alb-arn" {
  value = aws_lb.wordpress_alb.arn
}

output "alb-dnsname" {
  value = aws_lb.wordpress_alb.dns_name
}

output "alb-zone_id" {
  value = aws_lb.wordpress_alb.zone_id
}