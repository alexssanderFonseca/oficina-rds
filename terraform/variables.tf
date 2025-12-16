variable "vpc_id" {
  type    = string
  default = "vpc-0fb81a0a9aea53dab"
}

variable "subnets_id" {
  type    = list(any)
  default = ["subnet-0fcae672ce9da5b93", "subnet-07959d6d4df3f85be", "subnet-03664783107daf27a"]

}