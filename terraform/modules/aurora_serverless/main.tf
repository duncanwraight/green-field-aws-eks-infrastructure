resource "aws_db_subnet_group" "this" {
  name       = local.name
  subnet_ids = var.subnet_ids
}

resource "aws_rds_cluster" "this" {
  cluster_identifier = "${local.name}-cluster"

  database_name   = var.name
  master_username = var.name
  master_password = random_password.password.result

  backup_retention_period      = var.backup.retention_period
  preferred_backup_window      = var.backup.window
  preferred_maintenance_window = "Sun:03:32-Sun:04:32"

  engine_mode = "serverless"
  engine      = "aurora-${var.engine}"

  scaling_configuration {
    min_capacity             = 2
    max_capacity             = 8
    auto_pause               = true
    seconds_until_auto_pause = 3600 # 1 hour
    timeout_action           = "ForceApplyCapacityChange"
  }

  db_subnet_group_name = aws_db_subnet_group.this.name
  vpc_security_group_ids = concat(var.additional_security_group_ids, [
    aws_security_group.this.id
  ])

  storage_encrypted = true
  kms_key_id        = aws_kms_key.this.arn

  tags = merge(var.tags, {
    "Name" = var.name
  })

  lifecycle {
    prevent_destroy = true
  }
}
