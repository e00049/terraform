resource "google_project_service" "project" {
  for_each = toset ([
     cloudresourcemanager.google.com
     compute.google.com  
  ])
  project = "your-project-id"
  service = each.value
  disable_dependent_services = true  

  timeouts {
    create = "30m"
    update = "40m"
  }
}
