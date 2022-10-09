data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_s3_bucket" "this" {
  bucket = "aschemann-gitops-sample-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  tags = {
    Version    = var.deliverable_version
    Git-Commit = var.git_commit_id
  }
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "public-read"
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.this.arn}/*"
    ]
  }
}

resource "aws_s3_object_copy" "this" {
  bucket       = aws_s3_bucket.this.id
  key          = "index.html"
  source       = "aschemann-gitops-sample-repository-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}/index-${var.deliverable_version}.html"
  content_type = "text/html"
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }
}
