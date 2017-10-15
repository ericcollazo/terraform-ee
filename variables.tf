variable "do_token" {
  description = "Your Digital Ocean API token"
}

variable "public_key_path" {
  description = "Path to the SSH public key to be used for authentication"
}

variable "do_key_name" {
  description = "Name of the key on Digital Ocean"
  default = "docker keys"
}