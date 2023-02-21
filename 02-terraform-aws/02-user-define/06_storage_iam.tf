
# IAM User creation using Count Meta data
resource "aws_iam_user" "demo_user_list1" {
  name  = var.users_list1[count.index]
  count = 3
}
variable "users_list1" {
  type    = list(any)
  default = ["developer1", "developer2", "developer3"]
}

# IAM User creation using for_each 
resource "aws_iam_user" "demo_user_list2" {
  name     = each.key
  for_each = toset(var.users_list2)
}

variable "users_list2" {
  type    = list(any)
  default = ["admin1", "admin2", "admin3"]
}
