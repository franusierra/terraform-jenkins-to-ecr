resource "aws_ecr_repository" "jenkins_repo_test" {
  name = "jenkins-test"
}

data "aws_iam_policy_document" "push_ecr_policy" {
  statement {
    sid = ""

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage"
    ]

    resources = [
      aws_ecr_repository.jenkins_repo_test.arn
    ]
  }

}

resource "aws_iam_role" "jenkins_ecr_role" {
  name = "jenkins_ecr_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "schedule_lambda_role_policy" {
  name   = "jenkins_ecr_role"
  role   = aws_iam_role.jenkins_ecr_role.id
  policy = data.aws_iam_policy_document.push_ecr_policy.json
}
