output "terraform_state_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.terraform_state.id
}

output "terraform_state_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.terraform_state.arn
}

output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}

output "codebuild_project_name" {
  description = "Name of the CodeBuild project"
  value       = aws_codebuild_project.terraform.name
}

output "codebuild_role_arn" {
  description = "ARN of the IAM role assumed by CodeBuild"
  value       = aws_iam_role.codebuild.arn
}