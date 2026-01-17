# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket  = "ecs-project-homelab-backend-bucket005"
    key     = "ecs-terraform-github-action.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}