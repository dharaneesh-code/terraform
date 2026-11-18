# 1. Generate a random suffix so your bucket name is globally unique
resource "random_id" "suffix" {
  byte_length = 4
}

# 2. Your S3 Bucket (with unique name & force_destroy for easy cleanup)
resource "aws_s3_bucket" "example" {
  bucket        = "my-tf-test-bucket-${random_id.suffix.hex}"
  force_destroy = true

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

# 3. Block All Public Access (Recommended Security Best Practice)
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 4. Enable Versioning
resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.example.id

  versioning_configuration {
    status = "Enabled"
  }
}

# 5. Enable Default Encryption (AES-256)
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

