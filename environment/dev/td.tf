resource "aws_ecs_task_definition" "blue" {
  family                   = "${local.prefix}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = local.lab_role_arn
  task_role_arn            = local.lab_role_arn
  container_definitions = jsonencode([{
    name      = "${local.prefix}-container"
    image     = local.ecr_repo
    essential = true
    environment = [
      { "name" : "REGION", "value" : local.region },
      { "name" : "DBPORT", "value" : tostring(aws_db_instance.this.port) },
      { "name" : "DBHOST", "value" : aws_db_instance.this.address },
      { "name" : "DATABASE", "value" : aws_db_instance.this.db_name },
      { "name" : "DBUSER", "value" : aws_db_instance.this.username },
    ]
    secrets : [
      {
        "name" : "DBPWD",
        "valueFrom" : aws_secretsmanager_secret.this.arn
      }
    ]
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.container_port
      hostPort      = var.container_port
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = local.log_group
        awslogs-stream-prefix = "/aws/ecs"
        awslogs-region        = local.region
      }
    }
  }])

  tags = {
    Name        = "${local.prefix}-task"
    Environment = var.stage
  }
}

