resource "aws_ecr_repository" "foo" {
  for_each             = toset(local.ecr_names)
  name                 = each.key
  image_tag_mutability = "MUTABLE"
  tags = {
    Name = "${local.project}-${local.env}-ecr"
  }
}
