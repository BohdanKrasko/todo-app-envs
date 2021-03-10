terraform {
  source = "git@github.com:BohdanKrasko/infrastructure-modules.git?ref=v0.1.8"
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
  prod_json_go = "prod_go.json"
  s3_bucket_name = "prod-s3-bucket-frontend-todo-app-www.ekstodoapp.tk"
  go_image = "030209dbcac4.ngrok.io/repository/krasko:wed"
  env = "prod"


}
