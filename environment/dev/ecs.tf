resource "aws_ecs_cluster" "this" {
  name = "${local.prefix}-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${local.prefix}-fargate-cluster"
  }
}
