locals {
  application_name = var.tags["Application"]
  environment      = var.tags["Environment"]
}



//create bucket
resource "aws_s3_bucket" "example-bucket" {
  bucket = "my-bucket-ksjndfkjdsnfksdjnfksjndfj"
  tags = {
    Name = "my-bucket"
  }
}


//ECS CLUSTER
module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = "ecs-${local.application_name}-${local.environment}"

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/${local.application_name}-${local.environment}"
      }
    }
  }

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 1
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 1
      }
    }
  }

  tags = var.tags
}

resource "aws_ecr_repository" "ecr_repository" {
  name                 = "ecr-repository-${local.application_name}-${local.environment}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role_${local.application_name}_${local.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecr_permissions" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecr_permissions.arn
}

resource "aws_iam_policy" "ecr_permissions" {
  name = "ecr_permissions_${local.application_name}_${local.environment}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}


//ECS TASK DEFINITION
resource "aws_ecs_task_definition" "service" {
  family                   = "service-${local.application_name}-${local.environment}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "${local.application_name}-${local.environment}-app"
      image     = aws_ecr_repository.ecr_repository.repository_url
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_security_group" "ecs_service_sg" {
  name        = "ecs_service_sg_${local.application_name}_${local.environment}"
  description = "Security group for ECS service"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//ECS SERVICE
resource "aws_ecs_service" "cloud-phoenix-app" {
  name            = "service-${local.application_name}-${local.environment}"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  #iam_role        = aws_iam_role.ecs_service_role.arn
  #depends_on      = [aws_iam_policy_attachment.ecs_service_policy_attachment]

  network_configuration {
    security_groups  = [aws_security_group.ecs_service_sg.id]
    subnets          = var.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "${local.application_name}-${local.environment}-container}"
    container_port   = 3000
  }
}


//APPLICATION LOAD BALANCER TARGET GROUP AND LISTENER
resource "aws_lb_target_group" "target_group" {
  name     = "${local.application_name}-${local.environment}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  tags = var.tags
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = var.load_balancer_arn
  port              = "80"
  protocol          = "HTTP"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
  #alpn_policy       = "HTTP2Preferred"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}