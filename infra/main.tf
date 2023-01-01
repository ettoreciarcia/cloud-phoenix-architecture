locals {
  application_name = var.tags["Application"]
  environment = var.tags["Environment"]
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

//ECS TASK DEFINITION
resource "aws_ecs_task_definition" "service" {
  family = "service"
  container_definitions = jsonencode([
    {
      name      = "${local.application_name}-${local.environment}-app"
      image     = aws_ecr_repository.ecr_repository.repository_url
      cpu       = 10
      memory    = 128
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 80
        }
      ]
    }
  ])

}

//ECS SERVICE
# resource "aws_ecs_service" "mongo" {
#   name            = "service-${local.application_name}-${local.environment}"
#   cluster         = module.ecs.cluster_id
#   task_definition = aws_ecs_task_definition.service.arn
#   desired_count   = 1
#   iam_role        = aws_iam_role.foo.arn
#   depends_on      = [aws_iam_role_policy.foo]

#   ordered_placement_strategy {
#     type  = "binpack"
#     field = "cpu"
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.foo.arn
#     container_name   = "mongo"
#     container_port   = 8080
#   }

#   placement_constraints {
#     type       = "memberOf"
#     expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
#   }
# }


//APPLICATION LOAD BALANCER TARGET GROUP AND LISTENER
resource "aws_lb_target_group" "target_group" {
  name     = "${local.application_name}-${local.environment}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  tags = var.tags
}

# resource "aws_lb_listener" "listener" {
#   load_balancer_arn = var.load_balancer_arn
#   port              = "80"
#   protocol          = "HTTP"
#   #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
#   #alpn_policy       = "HTTP2Preferred"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.target_group.arn
#   }
# }