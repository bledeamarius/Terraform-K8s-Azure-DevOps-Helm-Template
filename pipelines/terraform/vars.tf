
variable "env" {
  type        = string
  description = "Env name."
  default     = "test"
}

variable "location" {
  type        = string
  description = "Location where all the resources will be created."
  default     = "West Europe"
}

variable "usecase" {
  type        = string
  description = "Name of the project/usecase name."
  default     = "demo_usecase"
}