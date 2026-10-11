variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string

  validation {
    condition = (
      length(var.state_bucket_name) >= 3 &&
      length(var.state_bucket_name) <= 63 &&
      can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.state_bucket_name))
    )

    error_message = "The bucket name must contain 3-63 lowercase letters, numbers, or hyphens, and start and end with a letter or number."
  }
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}
variable "github_repository_url" {
  description = "HTTPS URL of the GitHub repository"
  type        = string
}

resource "aws_codebuild_webhook" "terraform" {
  project_name = aws_codebuild_project.terraform.name
  build_type   = "BUILD"

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "^refs/heads/main$"
    }
  }
}