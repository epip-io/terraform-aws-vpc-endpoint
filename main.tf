module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.14.0"
  attributes  = var.attributes
  namespace   = var.namespace
  environment = var.environment
  stage       = var.stage
  delimiter   = var.delimiter
  name        = var.name
  tags        = var.tags
}

data "aws_vpc_endpoint_service" "s3" {
  service = "s3"
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  service_name = data.aws_vpc_endpoint_service.s3.service_name
  tags         = module.label.tags
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  count = length(var.private_route_table_ids)

  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = element(var.private_route_table_ids, count.index)
}

resource "aws_vpc_endpoint_route_table_association" "public_s3" {
  count = length(var.public_route_table_ids)

  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = element(var.public_route_table_ids, count.index)
}

############################
# VPC Endpoint for DynamoDB
############################
data "aws_vpc_endpoint_service" "dynamodb" {
  service = "dynamodb"
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = var.vpc_id
  service_name = data.aws_vpc_endpoint_service.dynamodb.service_name
  tags         = module.label.tags
}

resource "aws_vpc_endpoint_route_table_association" "private_dynamodb" {
  count = length(var.private_route_table_ids)

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb.id
  route_table_id  = element(var.private_route_table_ids, count.index)
}

resource "aws_vpc_endpoint_route_table_association" "public_dynamodb" {
  count = length(var.public_route_table_ids)

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb.id
  route_table_id  = element(var.public_route_table_ids, count.index)
}
