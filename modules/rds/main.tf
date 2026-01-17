# Create a random password for the database
resource "random_password" "db" {
  length           = 20
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Create Secrets Manager secret to store the database password
resource "aws_secretsmanager_secret" "db_password" {
  name = "ithomelab/mysql/password"

  tags = {
    Name = "ithomelab-mysql-password"
  }
}

# Create a secret version with the generated password
resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.db.result
}


# Create a DB subnet group
resource "aws_db_subnet_group" "db-subnet" {
  name       = var.db_sub_name
  subnet_ids = [var.pri_sub_5a_id, var.pri_sub_6b_id] # Replace with your private subnet IDs
}

# Create RDS instance
resource "aws_db_instance" "db" {
  identifier              = "bookdb-instance"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  username                = var.db_username
  password                = aws_secretsmanager_secret_version.db_password.secret_string
  db_name                 = var.db_name
  multi_az                = true
  storage_type            = "gp2"
  storage_encrypted       = false
  publicly_accessible     = false
  skip_final_snapshot     = true
  backup_retention_period = 0
  multi_az = true  # <-- ADD THIS (AWS creates the standby automatically

  vpc_security_group_ids = [var.db_sg_id] # Replace with your desired security group ID

  db_subnet_group_name = aws_db_subnet_group.db-subnet.name

  tags = {
    Name = "my-db-instance"
  }
}
