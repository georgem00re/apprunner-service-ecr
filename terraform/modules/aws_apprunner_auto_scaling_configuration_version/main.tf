
resource "aws_apprunner_auto_scaling_configuration_version" "this" {
  auto_scaling_configuration_name = var.name

  // The maximum number of concurrent requests that an instance processes. 
  // When the number of concurrent requests exceeds this quota, 
  // App Runner scales up the service.
  max_concurrency = var.max_concurrency


  // The maximum number of instances that your service can scale up to. 
  // This is the highest number of instances that can concurrently 
  // handle your service's traffic.
  max_size = var.max_size

  // The minimum number of instances that App Runner can provision for 
  // your service. The service always has at least this number of provisioned instances. 
  min_size = var.min_size
}
