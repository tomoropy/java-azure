terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }

  # tf.stateファイルをAzure Storage Accountに保存する場合
  # 事前にStorage Accountを作成してから以下のコメントアウトを外してください
  # backend "azurerm" {
  #   resource_group_name  = "terraform-state-rg"
  #   storage_account_name = "terraformstate[ランダム文字列]"
  #   container_name       = "tfstate"
  #   key                  = "todo-app.terraform.tfstate"
  # }
}

provider "azurerm" {
  features {}
}
