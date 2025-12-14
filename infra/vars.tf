variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "hcloud_token" {
  description = "Hetzner Cloud Token"
  type        = string
}

variable "ssh_private_key" {
  description = "SSH Private Key"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH Public Key"
  type        = string
  sensitive   = true
}
