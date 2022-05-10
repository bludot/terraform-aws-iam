terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.12.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}

resource "aws_iam_role" "role" {
  name = var.role.name
  path = var.role.path

  force_detach_policies = true

  assume_role_policy = var.role.assume_role_policy
  tags = merge({
    createdBy = "terraform aws-iam/role"
  }, var.role.tags)
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  count      = length(var.role.policies)
  role       = aws_iam_role.role.name
  policy_arn = var.role.policies[count.index]
  depends_on = [
    aws_iam_role.role,
  ]
}

data "aws_caller_identity" "current" {}
