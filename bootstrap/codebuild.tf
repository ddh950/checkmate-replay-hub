# IAM role assumed by AWS CodeBuild
resource "aws_iam_role" "codebuild" {
  name = "checkmate-replay-hub-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "codebuild.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Project   = "CheckmateReplayHub"
    ManagedBy = "Terraform"
  }
}

# Permissions required for CodeBuild logging
resource "aws_iam_role_policy" "codebuild_logs" {
  name = "checkmate-replay-hub-codebuild-logs"
  role = aws_iam_role.codebuild.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]

        Resource = "*"
      }
    ]
  })
}

# CodeBuild project
resource "aws_codebuild_project" "terraform" {
  name         = "checkmate-replay-hub-terraform"
  description  = "Runs Terraform for Checkmate Replay Hub"
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "TF_IN_AUTOMATION"
      value = "true"
    }
  }

  source {
    type      = "GITHUB"
    location  = var.github_repository_url
    buildspec = "buildspec.yml"

    git_clone_depth = 1
  }

  tags = {
    Project   = "CheckmateReplayHub"
    ManagedBy = "Terraform"
  }
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