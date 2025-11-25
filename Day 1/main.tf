provider "aws" {
    region = "ap-south-1"
}
resource "aws_instance" "terraform_instance" {
    ami = "ami-0d176f79571d18a8f"
    instance_type = "t2.micro"
    security_groups = "launch-wizard-1"
    subnet_id = "subnet-02f07b6f3d815ce04"
    key_name = "terraform_key"
    tags = {
      Name = "EC2 - 1"
      Env = "Dev"
    }
}