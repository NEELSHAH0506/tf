
resource "aws_codestarconnections_connection" "github_connection" {
  name          = "${var.name}-github"
  provider_type = "GitHub"
}

resource "aws_codepipeline" "pipeline" {
  name     = var.name
  role_arn = var.codepipeline_role_arn

  artifact_store {
    type     = var.artifact_store_type
    location = var.artifact_store_location
  }

  stage {
    name = "Source"

    action {
      category = "Source"
      name     = "Source"
      owner    = "AWS"
      provider = "CodeStarSourceConnection"
      version  = "1"

      configuration = {
        ConnectionArn         = aws_codestarconnections_connection.github_connection.arn,
        OutputArtifactFormat  = "CODE_ZIP",
        FullRepositoryId      = var.full_repository_id
        BranchName            = var.branch_name
      }

      output_artifacts = ["SourceOutput"]
    }
  }

  dynamic "stage" {
    for_each = var.stages

    content {
      name = "Stage-${stage.value["name"]}"
      action {
        category         = stage.value["category"]
        name             = "Action-${stage.value["name"]}"
        owner            = stage.value["owner"]
        provider         = stage.value["provider"]
        input_artifacts  = [stage.value["input_artifacts"]]
        output_artifacts = stage.value["output_artifacts"] == null ? [] : [stage.value["output_artifacts"]]
        version          = "1"
        run_order        = index(var.stages, stage.value) + 2

        configuration = {
          ProjectName = stage.value["provider"] == "CodeBuild" ? "${var.name}-${stage.value["name"]}" : null

          /* ECS */
          ClusterName = lookup(stage.value, "ecs_cluster_name", null)
          ServiceName = lookup(stage.value, "ecs_service_name", null)
        }
      }
    }
  }
}
