resource "aws_s3_bucket" "terraform_states" {
  for_each = toset(var.environments)
  bucket   = "${var.name}-${each.key}-state"
  lifecycle {
    prevent_destroy = false
  }
}

output "states" {
  value = aws_s3_bucket.terraform_states["dev"].id
}

resource "aws_s3_bucket_versioning" "enabled" {
  for_each = toset(var.environments)
  bucket   = aws_s3_bucket.terraform_states[each.key].id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  for_each = toset(var.environments)
  bucket   = aws_s3_bucket.terraform_states[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  for_each     = toset(var.environments)
  name         = "${var.name}-${each.key}-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
