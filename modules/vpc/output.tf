output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "private_subnets_ids" {
  value = [aws_subnet.private_subnets[0].id, aws_subnet.private_subnets[1].id
  ]
}