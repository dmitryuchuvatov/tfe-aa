# Create Redis 

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "tfe-aa-redis"
  engine               = "redis"
  node_type            = "cache.t3.small"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.6"
  port                 = 6379
  security_group_ids   = [aws_security_group.sg.id]
  subnet_group_name    = aws_elasticache_subnet_group.redis.name
}

# Create Subnet group for Redis
resource "aws_elasticache_subnet_group" "redis" {
  name       = "tfe-aa-redis"
  subnet_ids = [aws_subnet.private1.id]
}