resource "aws_vpc_endpoint" "ecr-dkr-endpoint" {
  vpc_id              = module.vpc.vpc_id
  private_dns_enabled = true
  service_name        = "com.amazonaws.${local.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [module.vpce_sg.id]
  subnet_ids          = module.dynamic_subnets.private_subnet_ids
  tags = {
    "Name" = "${local.prefix}-vpce-ecr.dkr"
  }
}

resource "aws_vpc_endpoint" "ecr-api-endpoint" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${local.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [module.vpce_sg.id]
  subnet_ids          = module.dynamic_subnets.private_subnet_ids
  tags = {
    "Name" = "${local.prefix}-vpce-ecr.api"
  }
}

resource "aws_vpc_endpoint" "ecs-agent" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${local.region}.ecs-agent"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [module.vpce_sg.id]
  subnet_ids          = module.dynamic_subnets.private_subnet_ids
  tags = {
    "Name" = "${local.prefix}-vpce-ecs-agent"
  }
}

resource "aws_vpc_endpoint" "ecs-telemetry" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${local.region}.ecs-telemetry"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [module.vpce_sg.id]
  subnet_ids          = module.dynamic_subnets.private_subnet_ids
  tags = {
    "Name" = "${local.prefix}-vpce-ecs-telemetry"
  }
}

resource "aws_vpc_endpoint" "ecs" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${local.region}.ecs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [module.vpce_sg.id]
  subnet_ids          = module.dynamic_subnets.private_subnet_ids
  tags = {
    "Name" = "${local.prefix}-vpce-ecs"
  }

}


module "vpce_sg" {
  source     = "cloudposse/security-group/aws"
  version    = "2.0.0-rc1"
  attributes = ["vpce-sg"]

  # Allow unlimited egress
  allow_all_egress = true

  rule_matrix = [
    # Allow any of these security groups
    {
      source_security_group_ids = [module.ecs_service_sg.id]
      self                      = null
      rules = [
        {
          key         = "HTTPS"
          type        = "ingress"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          description = "Allow HTTPS from Task SG"
        }
      ]
    }
  ]

  vpc_id = module.vpc.vpc_id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${local.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = module.dynamic_subnets.private_route_table_ids
  policy            = data.aws_iam_policy_document.s3_ecr_access.json
  tags = {
    "Name" = "${local.prefix}-vpce-S3"
  }

}

data "aws_iam_policy_document" "s3_ecr_access" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::prod-${local.region}-starport-layer-bucket/*",
    ]
  }

}
