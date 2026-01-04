output "rds_endpoint" {
  description = "Endpoint de conexão do RDS"
  value       = aws_db_instance.academico_rds.endpoint
}

output "rds_address" {
  description = "Endereço do RDS"
  value       = aws_db_instance.academico_rds.address
}

output "rds_port" {
  description = "Porta do RDS"
  value       = aws_db_instance.academico_rds.port
}

output "secret_arn" {
  description = "ARN do Secret Manager com as credenciais"
  value       = data.aws_secretsmanager_secret.rds_credentials.arn
}

output "secret_name" {
  description = "Nome do Secret no Secrets Manager"
  value       = data.aws_secretsmanager_secret.rds_credentials.name
}

output "database_name" {
  description = "Nome do banco de dados"
  value       = aws_db_instance.academico_rds.db_name
}


output "connection_info" {
  description = "Como conectar ao banco"
  value       = <<-EOT
    
    📋 INFORMAÇÕES DE CONEXÃO:
    
    1. Recuperar credenciais do Secrets Manager:
       aws secretsmanager get-secret-value --secret-id ${data.aws_secretsmanager_secret.rds_credentials.name} --region us-east-1
    
    2. Ou via AWS CLI com jq:
       aws secretsmanager get-secret-value --secret-id ${data.aws_secretsmanager_secret.rds_credentials.name} --query SecretString --output text | jq .
    
    3. Endpoint: ${aws_db_instance.academico_rds.endpoint}
    
    ⚠️ IMPORTANTE: Sempre PARE ou EXCLUA o RDS ao final do uso!
  EOT
}
