
# Secret Manager - Armazenar credenciais do RDS
resource "aws_secretsmanager_secret" "rds_credentials" {
  name        = "rds-academico-credentials"
  description = "Credenciais do banco RDS academico"

  recovery_window_in_days = 0 # Permite deletar imediatamente (útil para testes)

  tags = {
    Name        = "RDS-Academico-Credentials"
    Environment = "academico"
  }
}

# Versão do Secret com as credenciais
resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id = aws_secretsmanager_secret.rds_credentials.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.rds_password.result
    engine   = "postgres"
    host     = aws_db_instance.academico_rds.address
    port     = aws_db_instance.academico_rds.port
    dbname   = "academicodb"
  })

  depends_on = [aws_db_instance.academico_rds]
}
