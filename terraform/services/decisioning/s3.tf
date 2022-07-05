resource "aws_s3_bucket" "decisioning" {
  bucket = "${local.name}-decisioning-${var.environment}"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT"]
    allowed_origins = [var.cors_allowed_origin]
    expose_headers  = []
    max_age_seconds = 3000
  }

  logging {
    target_bucket = aws_s3_bucket.decisioning_logs.id
  }
}

resource "aws_s3_bucket_public_access_block" "decisioning" {
  bucket                  = aws_s3_bucket.decisioning.bucket
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "decisioning_logs" {
  bucket = "${local.name}-decisioning-${var.environment}-logs"

  acl = "log-delivery-write"

  lifecycle_rule {
    id      = "cleanup"
    enabled = true

    expiration {
      days = 90
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "decisioning_logs" {
  bucket                  = aws_s3_bucket.decisioning_logs.bucket
  ignore_public_acls      = true
  restrict_public_buckets = true
}
