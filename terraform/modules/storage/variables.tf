variable "backend_bucket" {
  type = object({
    bucket_name      = string
    force_destroy    = bool
    object_ownership = string
  })
}

variable "tags" {
  type = map(any)
}

variable "cloudfront_bucket" {
  type = object({
    bucket_name = string
  })
}