variable "bucket_name" {
  description = "S3 Bucket Name"
  type = string
  default = "archspace-studio-static"
}

variable "folder" {
  description = "Name of the Folder to Upload"
  type = string
  default = "archspace-studio"
}