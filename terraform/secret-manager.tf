
# Versão do Secret com as credenciais
resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id = "arn:aws:secretsmanager:us-east-1:305448253775:secret:secrets-XmZ0Fb"
  secret_string = jsonencode({
    username = aws_db_instance.academico_rds.username
    password = random_password.rds_password.result
    engine   = aws_db_instance.academico_rds.engine
    host     = aws_db_instance.academico_rds.address
    port     = aws_db_instance.academico_rds.port
    dbname   = aws_db_instance.academico_rds.db_name
  })

  lifecycle {
    ignore_changes = [
      secret_string,
    ]
  }


  depends_on = [aws_db_instance.academico_rds]
}
