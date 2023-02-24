
variable "name" {
  description = "Pipeline name"
  type = string
}

variable "codepipeline_role_arn" {
  description = "ARN of the codepipeline IAM role"
  type        = string
}

variable "artifact_store_type" {
  description = "The type of the artifact store, such as Amazon S3"
  type = string
}

variable "artifact_store_location" {
  description = "The location where AWS CodePipeline stores artifacts for a pipeline; currently only S3 is supported"
  type = string
}

variable "full_repository_id" {
  description = "The owner and name of the repository where source changes are to be detected. Example: some-user/my-repo"
  type = string
}

variable "branch_name" {
  description = "The name of the branch where source changes are to be detected."
  type = string
}

variable "stages" {
  description = "List of Map containing information about the stages of the CodePipeline"
  type        = list(map(any))
}
