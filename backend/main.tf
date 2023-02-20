
/* DynamoDB table */

resource "aws_dynamodb_table" "state_lock" {
  name           = "${var.backend_name}-terraform-state"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = local.tags
}

/* S3 Bucket */

resource "aws_s3_bucket" "state_bucket" {
  bucket = "${var.backend_name}-tf-backend"
  force_destroy = false

  tags = local.tags
}

/* Private ACL */
resource "aws_s3_bucket_acl" "state_bucket" {
  bucket  = aws_s3_bucket.state_bucket.id
  acl     = "private"
}

/* Enable versioning */
resource "aws_s3_bucket_versioning" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

/* Encryption */

resource "aws_kms_key" "state_bucket" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = local.tags
}

resource "aws_kms_alias" "key_alias" {
  name          = "alias/tf-${var.backend_name}-bucket-key"
  target_key_id = aws_kms_key.state_bucket.key_id
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
      kms_master_key_id = aws_kms_key.state_bucket.arn
    }
  }
}

/* Public access block */

resource "aws_s3_bucket_public_access_block" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

/* Policy document, deny unencrypted access */

data "aws_iam_policy_document" "state_bucket" {
  statement {
    sid = "DenyObjectsThatAreNotSSEKMSWithSpecificKey"
    principals {
      identifiers = ["*"]
      type        = "*"
    }
    effect      = "Deny"
    actions     = [ "s3:PutObject" ]
    resources   = [ "${aws_s3_bucket.state_bucket.arn}/*" ]

    condition {
      test     = "ArnNotEqualsIfExists"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values   = [aws_kms_key.state_bucket.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id
  policy = data.aws_iam_policy_document.state_bucket.json
}

