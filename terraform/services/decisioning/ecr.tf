
resource "aws_ecr_repository" "decisioning" {
  name = "decisioning"
}

resource "aws_ecr_lifecycle_policy" "decisioning" {
  repository = aws_ecr_repository.decisioning.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Ensure 'latest' tag always exists in repository",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["latest"],
                "countType": "imageCountMoreThan",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 2,
            "description": "Keep last ${var.aws_ecr_lifecycle_num_images_to_keep} images for decisioning service",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": ${var.aws_ecr_lifecycle_num_images_to_keep}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

resource "aws_ecr_repository" "decisioning_migrations" {
  name = "decisioning-migrations"
}

resource "aws_ecr_lifecycle_policy" "decisioning_migrations" {
  repository = aws_ecr_repository.decisioning_migrations.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Ensure 'latest' tag always exists in repository",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["latest"],
                "countType": "imageCountMoreThan",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 2,
            "description": "Keep last ${var.aws_ecr_lifecycle_num_images_to_keep} images for decisioning-migrations service",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": ${var.aws_ecr_lifecycle_num_images_to_keep}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
