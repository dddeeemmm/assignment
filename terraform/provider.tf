# Select a specific provider version to ensure compatibility
# and stable operation of the developed configuration
terraform {
  required_providers {
    aws = {
      # Use the CROC Cloud local mirror
      # to download c2devel/croccloud provider
      source  = "hc-registry.website.cloud.croc.ru/c2devel/croccloud"
      version = "4.14.0-CROC1"
    }
  }
}

# Connect and configure the provider to work
# with all CROC Cloud services except for object storage
provider "aws" {
  endpoints {
    ec2 = "https://api.cloud.croc.ru"
  }

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_region_validation      = true

  insecure   = false
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "croc"
}

# Connect and configure the provider to work
# with the CROC Cloud object storage
provider "aws" {
  alias = "noregion"
  endpoints {
    s3 = "https://storage.cloud.croc.ru"
  }

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_region_validation      = true

  insecure   = false
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "us-east-1"
}