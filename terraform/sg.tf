resource "aws_security_group" "rds_sg" {
  name        = "rds-academico-sg"
  description = "Security group para RDS academico"
  vpc_id      = var.vpc_id
  
  # Permite conexões PostgreSQL
  ingress {
    from_port   = 5432 # Use 3306 para MySQL, 1433 para SQL Server
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ⚠️ RECOMENDADO: Altere para seu IP específico
    description = "Acesso PostgreSQL"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "rds-academico-sg"
    Environment = "academico"
  }
}