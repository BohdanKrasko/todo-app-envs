terraform {
  source = "git@github.com:BohdanKrasko/infrastructure-modules.git?ref=v1.3.1"
}

remote_state {
    backend  = "s3"
    generate = {
        path      = "backend.tf"
        if_exists = "overwrite"
    }
    config = {
        bucket = "stage-ecs-ter"

        key = "${path_relative_to_include()}/terraform.tfstate"
        region         = "us-east-1"
        encrypt        = true
        dynamodb_table = "stage-lock-db"
    }

}

generate "provider" {
        path = "provider.tf"
        if_exists = "overwrite"
        contents = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.23.0"
    }
  }
}

provider "aws" {
    region                  = "us-east-1"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "default"
}
    EOF
}

inputs = {
  vpc_name = "stage"
  igw_name = "stage_igw"
  aws_lb_target_group = "stage-target-group"
  aws_lb_name = "stage-lb-name"
  aws_service_discovery_private_dns_namespace_go_name = "stage-todo"
  aws_service_discovery_service_mongo_name = "mongo"
  aws_ecs_cluster_name = "stage-todo"
  aws_ecs_task_definition_go_family = "stage-go"
  aws_ecs_task_definition_mongo_family = "stage-mongo"
  aws_ecs_service_go_name = "stage-go"
  aws_ecs_service_mongo_name = "stage-mongo"
  aws_route53_record_go_name = "stage.go.ekstodoapp.tk"
  aws_route53_record_clodfront_name = "stage.ekstodoapp.tk"
  env = "stage"
  acm_certificate_arn = "arn:aws:acm:us-east-1:882500013896:certificate/0b434d20-a495-4105-b945-c6b85f17ec46"
  lambda_arn = "arn:aws:lambda:us-east-1:882500013896:function:add_security_headers:2"
  secret_manager_arn = "arn:aws:secretsmanager:us-east-1:882500013896:secret:nexus_cred_todo_app-yQKFr2"
  public_hosted_zone_id = "Z05340611QTGXY4HN6R2I"
}
