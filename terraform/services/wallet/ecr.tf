
resource "aws_ecr_repository" "wallet" {
  name = "wallet"
}

resource "aws_ecr_lifecycle_policy" "wallet" {
  repository = aws_ecr_repository.wallet.name

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
            "description": "Keep last ${var.aws_ecr_lifecycle_num_images_to_keep} images for wallet service",
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

resource "aws_ecr_repository" "wallet_migrations" {
  name = "wallet-migrations"
}

resource "aws_ecr_lifecycle_policy" "wallet_migrations" {
  repository = aws_ecr_repository.wallet_migrations.name

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
            "description": "Keep last ${var.aws_ecr_lifecycle_num_images_to_keep} images for wallet-migrations service",
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
