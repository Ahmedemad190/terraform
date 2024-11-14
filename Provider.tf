terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.75.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
 
}

resource "aws_iam_user" "example" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}

variable "user_names" {
  description = "List of IAM usernames"
  type        = list(string) 
  default     = ["user1"]
}

output "arn_fornew" {
  value = aws_iam_user.example[*].arn
}