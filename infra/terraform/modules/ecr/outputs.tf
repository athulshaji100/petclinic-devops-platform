output "repository_urls" {
  value = {
    for service, repo in aws_ecr_repository.petclinic :
    service => repo.repository_url
  }
}