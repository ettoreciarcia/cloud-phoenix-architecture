//create bucket
resource "aws_s3_bucket" "example-bucket" {
  bucket = "my-bucket-ksjndfkjdsnfksdjnfksjndfj"
  tags = {
    Name = "my-bucket"
  }
}