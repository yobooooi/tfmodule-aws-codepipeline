resource "aws_codebuild_project" "codebuild_project" {
    name         = "codebuild-${var.project_name}"
    description  = var.project_description
    service_role = aws_iam_role.codebuild_role.arn

    artifacts {
        type                 = "CODEPIPELINE"
        artifact_identifier  = "build.log"
    }

    environment {
        compute_type    = "BUILD_GENERAL1_SMALL"
        type            = "LINUX_CONTAINER"
        image           = "aws/codebuild/standard:2.0"
        privileged_mode = true

        dynamic "environment_variable" {
            for_each = var.environment_vars
            
            content {
                name  = environment_variable.key
                value = environment_variable.value
            }
        }
    }
    source {
        type     = "CODEPIPELINE"
        location = data.aws_codecommit_repository.source_repository.repository_name
    }
}