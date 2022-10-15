variable "deliverable_version" {
  type        = string
  default     = "v1"
  description = "Version of the deliverable to be deployed"
}

variable "git_commit_id" {
  type        = string
  default     = "unknown"
  description = "The Git Commit reference which was used to change this resource"
}
