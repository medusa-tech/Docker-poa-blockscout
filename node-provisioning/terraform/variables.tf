variable "do_token" {
  type = string
  description = "DigitalOcean Personal Access Token"
}

// useless?
variable "pub_key" {
  type = string
  description = "The public ssh key for the digital ocean resources"
}

variable "pvt_key" {
  type = string
  description = "The private key for the digital ocean resources"
}

// useless?
variable "node_id" {
  type = number
  description = "The ETH node id"
}

// useless?
variable "json_key" {
  type = string
  description = "The ETH node json account password"
}
