# Add the API
resource "aws_api_gateway_rest_api" "app_api" {
  name        = "{{ cookiecutter.project_slug }}_api"
  description = "API endpoints for {{ cookiecutter.project_slug }} lambda functions"
}

# Add a gateway for the API
resource "aws_api_gateway_resource" "proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.app_api.id
  parent_id   = aws_api_gateway_rest_api.app_api.root_resource_id

  path_part = "{proxy+}"
}

# Define an API method
resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.app_api.id
  resource_id   = aws_api_gateway_resource.proxy_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Connect our endpoint's incoming stuff to our Lambda function
resource "aws_api_gateway_integration" "lambda_proxy_integration" {
  rest_api_id             = aws_api_gateway_rest_api.app_api.id
  resource_id             = aws_api_gateway_resource.proxy_resource.id
  http_method             = aws_api_gateway_method.proxy_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = element(aws_lambda_function.app_function.*.invoke_arn, 2)
}

# Special definition for the root method
resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.app_api.id
  resource_id   = aws_api_gateway_rest_api.app_api.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

# Special definition for the root integration
resource "aws_api_gateway_integration" "lambda_root_proxy_integration" {
  rest_api_id = aws_api_gateway_rest_api.app_api.id
  resource_id = aws_api_gateway_method.proxy_root.resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = element(aws_lambda_function.app_function.*.invoke_arn, 2)
}

# Deploy the API and make it publicly available
resource "aws_api_gateway_deployment" "app_gateway_deployment" {
  depends_on  = [aws_api_gateway_integration.lambda_proxy_integration, aws_api_gateway_integration.lambda_root_proxy_integration]
  rest_api_id = aws_api_gateway_rest_api.app_api.id
  stage_name  = "production"
}

# Make sure API Gateway has correct perms to call our lambda function
resource "aws_lambda_permission" "api_gateway_to_app_function_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = element(aws_lambda_function.app_function.*.arn, 2)
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_deployment.app_gateway_deployment.execution_arn}/*/*"
}

output "base_url" {
  value = aws_api_gateway_deployment.app_gateway_deployment.invoke_url
}
