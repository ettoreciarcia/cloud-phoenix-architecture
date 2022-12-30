//create bucket
resource "aws_s3_bucket" "example-bucket" {
  bucket = "my-bucket-ksjndfkjdsnfksdjnfksjndfj"
  tags = {
    Name = "my-bucket"
  }
}

resource "aws_s3_bucket" "example-bucket" {
  bucket = "my-bucket2-ksjndfkjdsnfksdjnfksjndfj"
  tags = {
    Name = "my-bucket"
  }
}

resource "aws_s3_bucket" "example-bucket" {
  bucket = "my-bucket3-ksjndfkjdsnfksdjnfksjndfj"
  tags = {
    Name = "my-bucket"
  }
}