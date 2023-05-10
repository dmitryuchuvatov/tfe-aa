#Create RDS instance

resource "aws_db_instance" "rds" {
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "12"
  instance_class         = "db.t3.large"
  username               = "postgres"
  password               = "Password1$"
  parameter_group_name   = "default.postgres12"
  skip_final_snapshot    = true
  db_name                = "tfe"
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  identifier             = "tfe-aa-rds"
  tags = {
    Name = "tfe-aa-rds"
  }

  #depends_on = [
    #aws_s3_object.object_bootstrap
  #]
}

# Create RDS DB subnet group resource

resource "aws_db_subnet_group" "rds" {
  name       = "main"
  subnet_ids = [aws_subnet.private1.id, aws_subnet.private2.id]

  tags = {
    Name = "tfe-aa-subnet-group"
  }
}