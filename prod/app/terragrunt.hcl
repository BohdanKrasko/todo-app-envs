terraform {
  source = "git@github.com:BohdanKrasko/infrastructure-modules.git?ref=v1.3.0"
  
  
}

remote_state {
    backend  = "s3"
    generate = {
        path      = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
    config = {
        bucket = "tr-bucket-kr-v"

        key = "${path_relative_to_include()}/terraform.tfstate"
        region         = "us-east-1"
        encrypt        = true
        dynamodb_table = "terraform-state-lock-dynamo"
        
        
    }

}

generate "provider" {
        path = "provider.tf"
        if_exists = "overwrite_terragrunt"
        contents = <<EOF
provider "aws" {
    region                  = "us-east-1"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "default"
    required_providers {
          aws = {
            sourse  = "hashicorp/aws"
            version = "~> 3.23.0"
          }
        }
}
    EOF
}

inputs = {
  vpc_name = "prod"
  igw_name = "prod_igw"
  aws_lb_target_group = "prod-target-group"
  aws_lb_name = "prod-lb-name"
  aws_service_discovery_private_dns_namespace_go_name = "prod-todo"
  aws_service_discovery_service_mongo_name = "mongo"
  aws_ecs_cluster_name = "prod-todo"
  aws_ecs_task_definition_go_family = "prod-go"
  aws_ecs_task_definition_mongo_family = "prod-mongo"
  aws_ecs_service_go_name = "prod-go"
  aws_ecs_service_mongo_name = "prod-mongo"
  aws_route53_record_go_name = "prod.go.ekstodoapp.tk"
  aws_route53_record_clodfront_name = "prod.ekstodoapp.tk"
  env = "prod"
  acm_certificate_arn = "arn:aws:acm:us-east-1:882500013896:certificate/0b434d20-a495-4105-b945-c6b85f17ec46"
  lambda_arn = "arn:aws:lambda:us-east-1:882500013896:function:add_security_headers:2"
  secret_manager_arn = "arn:aws:secretsmanager:us-east-1:882500013896:secret:nexus_cred_todo_app-yQKFr2"
  public_hosted_zone_id = "Z05340611QTGXY4HN6R2I"
}
