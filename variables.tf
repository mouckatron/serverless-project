
variable "appname" {
  description = "Name of your app, used as name or prefix for resources and applied as tag for cost tracking"
  type        = string
}

variable "root_domain" {
  description = "Root domain which this app will be hosted at"
  type        = string
}

variable "lambda_functions" {
  description = "A list of maps detailing the lambda functions"
  type        = list
  default     = []
}
