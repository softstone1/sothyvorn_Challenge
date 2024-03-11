# Challenge 1
## Infra
- Github repository: https://github.com/softstone1/sothyvorn_Challenge
- demo url: https://ec2-54-159-135-51.compute-1.amazonaws.com/
- Use terraform to create an ec2 instance with a security group, and use cloud-init to execute ansible playbook
- Use webserver-setup ansible playbook to configure nginx server with static content, create self-certificate and perform https redirection
- Run terraform init and apply it to provision the infrastructure.
- Test and verify https connection with web_test.go

### Monitoring

1. CloudWatch: AWS CloudWatch can be used to collect and track metrics, collect and monitor log files, set alarms, and automatically react to changes to your AWS resources.

### Scaling

1. Auto Scaling: AWS Auto Scaling can be used to automatically adjust the number of EC2 instances in response to traffic patterns.

2. Elastic Load Balancing (ELB): ELB automatically distributes incoming application traffic across multiple targets, such as EC2 instances. Ensures that only healthy EC2s serve traffic by performing health checks. ELB works hand in hand with EC2 Auto Scaling to scale your application.

## Coding
- Implement credit card validation with unit tests in creditcard package and main.go in cmd

# Challenge 2
- Use a seperate github repository: https://github.com/softstone1/twick
- Reblit: https://replit.com/@softstone1/twick?v=1