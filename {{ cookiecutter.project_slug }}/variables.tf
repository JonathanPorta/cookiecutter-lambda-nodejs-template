variable "access_key" {}
variable "secret_key" {}
variable "region" {}
variable "circle_key" {}

variable "app_name" {
  description = "short name of this app"
  default     = ""
}

variable "function_name" {
  description = "List of the name of the function for the handlers for which to create lambda functions - needs to match the list defined in terraform variable 'function_handler'"
  type        = list(string)
  default     = ["{{ cookiecutter.handler_name }}"]
}

variable "function_handler" {
  description = "List of the handlers for which to create lambda functions"
  type        = list(string)
  default     = ["{{ cookiecutter.handler_name }}.handle"]
}

variable "function_runtime" {
  description = "Desired lambda runtime to use"
  default     = "nodejs12.x"
}
