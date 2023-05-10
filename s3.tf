# Create S3 buckets

resource "aws_s3_bucket" "tfe-aa-bucket" {
  bucket        = "tfe-aa-bucket"
  force_destroy = true

  tags = {
    Name = "tfe-aa-bucket"
  }
}

resource "aws_s3_bucket" "tfe-aa-software" {
  bucket        = "tfe-aa-software"
  force_destroy = true

  tags = {
    Name = "tfe-aa-bucket-software"
  }
} 

# Upload files for Airgap installation