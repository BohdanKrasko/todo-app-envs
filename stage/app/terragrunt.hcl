terraform {
  source = "git@github.com:BohdanKrasko/infrastructure-modules.git?ref=v0.1.7"
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
  prod_json_go = "stage_go.json"
  s3_bucket_name = "stage-s3-bucket-frontend-todo-app-www.ekstodoapp.tk"
  go_image = "030209dbcac4.ngrok.io/repository/krasko:wed"
  env = "stage"
}
