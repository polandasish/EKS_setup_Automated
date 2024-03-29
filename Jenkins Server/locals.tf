locals {
  inbound-rules = [
    { port     = 80
      protocol = "tcp"
    },
    {
      port     = 443
      protocol = "tcp"
    },
    {
      port     = 8080
      protocol = "tcp"
    },
    {
      port     = 22
      protocol = "tcp"
    },
    {
      port=6443
      protocol="tcp"
    }
    
  ]
}