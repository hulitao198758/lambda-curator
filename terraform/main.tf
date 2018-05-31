data "aws_region" "current" {}

data "aws_iam_policy_document" "lambda" {
  statement {
    sid = "1"

    actions = [
      "es:*",
    ]

    resources = [
      "*",
    ]
  }
}

module "lambda" {
  source = "github.com/harmy/terraform-aws-lambda"
  function_name = "lambda-curator-${var.stage}-${data.aws_region.current.name}"
  description   = "Auto ES indices cleaning"
  handler       = "main.lambda_handler"
  runtime       = "python3.6"
  timeout       = 300

  source_path = "${path.module}/../lambda"

  attach_policy = true
  policy        = "${data.aws_iam_policy_document.lambda.json}"

  log_retention_days = 7
  schedule_expression = "${var.schedule_expression}"
  enabled = "${var.enabled}"
}