provider "aws" {
  region = "us-east-1" 
}

resource "random_password" "rds_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-academico-subnet-group"
  subnet_ids = var.subnets_id
  tags = {
    Name        = "RDS Academico Subnet Group"
    Environment = "academico"
  }
}

resource "aws_db_instance" "academico_rds" {
  identifier            = "academico-rds"
  engine                = "postgres" 
  engine_version        = "18"
  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  max_allocated_storage = 0
  storage_type          = "gp2"
  storage_encrypted     = false
  db_name               = "oficinadb"
  username              = "userOficinaDb"
  password              = random_password.rds_password.result
  
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = true
  port                   = 5432
  
  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false
  copy_tags_to_snapshot   = false
  multi_az                = false
  
  monitoring_interval             = 0
  enabled_cloudwatch_logs_exports = []
  performance_insights_enabled    = false
  auto_minor_version_upgrade      = true
  maintenance_window              = "sun:03:00-sun:04:00"
  apply_immediately               = true
  
  tags = {
    Name        = "RDS-Academico"
    Environment = "academico"
    ManagedBy   = "Terraform"
  }
}

resource "null_resource" "db_init" {
  depends_on = [aws_db_instance.academico_rds]

  provisioner "local-exec" {
    command = <<-EOT
      echo "Aguardando RDS ficar disponível..."
      sleep 90
      
      echo "Executando script de inicialização..."
      PGPASSWORD='${random_password.rds_password.result}' psql \
        -h ${aws_db_instance.academico_rds.address} \
        -U ${aws_db_instance.academico_rds.username} \
        -d ${aws_db_instance.academico_rds.db_name} \
        -p 5432 \
        -f ${path.module}/scripts/init.sql
      
      echo "Script executado com sucesso!"
    EOT
  }

  # Força a re-execução se o RDS for recriado
  triggers = {
    db_instance_id = aws_db_instance.academico_rds.id
  }
}

