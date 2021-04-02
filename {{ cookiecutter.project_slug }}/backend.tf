terraform {
  backend "s3" {
    bucket = "{{ cookiecutter.tf_backend_s3_bucket }}"
    key    = "{{ cookiecutter.tf_backend_s3_key }}"
    region = "{{ cookiecutter.tf_backend_s3_region }}"
  }
}
