# definition of the variables. #

# variable "fn_name" {
#   type        = string
#   description = "function  name"
# }

# variable "fn_runtime" {
#   type        = string
#   description = "function runtime"
# }

# variable "fn_available_memory_mb" {
#   type        = string
#   description = "function available memory"
# }

variable "gcp_region" {
  type        = string
  description = "GCP region"
}

variable "gcp_project" {
  type        = string
  description = "GCP project name"
}

variable "inbucket_name" {
  type    = string
  default = "The name of the GCS bucket for inbound payload to be created"
}

variable "arbucket_name" {
  type    = string
  default = "The name of the GCS bucket for archived payload to be created"
}

variable "erbucket_name" {
  type    = string
  default = "The name of the GCS bucket for errored payload to be created"
}

variable "storage_class" {
  type        = string
  description = "The storage class of the GCS bucket"
}

variable "gcp_topicname" {
  type        = string
  description = "milestone topic"
}

variable "gcp_milestone_subs" {
  type        = string
  description = "milestone topic subscription"
}

variable "ack_deadline" {
  type        = string
  description = "milestone topic acknowledgment deadline"
}

variable "ret_duration" {
  type        = string
  description = "milestone topic message retention duration"
}

variable "s_account" {
  type        = string
  description = "service account used in the topic"
}

###################### Below code is working ######################

# variable "gcp_region" {
#   type        = string
#   description = "GCP region"
# }

# variable "gcp_project" {
#   type        = string
#   description = "GCP project name"
# }

# variable "inbucket_name" {
#   type    = string
#   default = "The name of the GCS bucket for inbound payload to be created"
# }

# variable "arbucket_name" {
#   type    = string
#   default = "The name of the GCS bucket for archived payload to be created"
# }

# variable "erbucket_name" {
#   type    = string
#   default = "The name of the GCS bucket for errored payload to be created"
# }

# variable "storage_class" {
#   type        = string
#   description = "The storage class of the GCS bucket"
# }