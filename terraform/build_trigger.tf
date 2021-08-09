resource "null_resource" "my_lambda_buildstep" {
  triggers = {
    handler      = "${filebase64sha256("../lamda/code/my_lambda_function_with_dependencies/welcome.py")}"
    requirements = "${filebase64sha256("../lamda/code/my_lambda_function_with_dependencies/requirements.txt")}"
    build        = "${filebase64sha256("../lamda/code/my_lambda_function_with_dependencies/build.sh")}"
  }

  provisioner "local-exec" {
    command = "../lamda/code/my_lambda_function_with_dependencies/build.sh"
  }
}


data "archive_file" "my_lambda_function_with_dependencies" {
  source_dir  = "../lamda/code/my_lambda_function_with_dependencies/"
  output_path = "../lamda/code/my_lambda_function_with_dependencies.zip"
  type        = "zip"

  depends_on = [null_resource.my_lambda_buildstep]
}


resource "aws_lambda_function" "my_lambda_function_with_dependencies" {
  function_name    = "my_lambda_function_with_dependencies"
  handler          = "welcome.hello"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  runtime          = "python3.7"
  timeout          = 60
  filename         = "${data.archive_file.my_lambda_function_with_dependencies.output_path}"
  source_code_hash = "${data.archive_file.my_lambda_function_with_dependencies.output_base64sha256}"
}

