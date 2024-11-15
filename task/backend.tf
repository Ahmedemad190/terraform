terraform {
  backend "s3" {
    bucket         = "my-terraform-test123"        
    key            = "gloable/project/my-terraform.tfstate"     
    region         = "us-east-1"                       
    dynamodb_table = "terraform-lock-table"             
    
  }
}
