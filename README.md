## RUSK WEBSERVICE INFRASTRUCTURE

Demo DevOps project utilizing Terraform, Ansible, Jenkins, Docker and hosted in AWS. This project will automatically setup AWS VPC with one public subnetwork and two EC2 instances in it, one for Jenkins and one for docker swarm. Each of instances has its own security group and Elastic IP. Elastic Container Registry is created for handling docker image transfers from Jenkins pipeline to webworkers. For communication between instances and for ansible provisioning, two key pairs are generated and downloaded / injected into required locations.

EC2 instances are provisioned with Ansible. Jenkins instance, besides getting Jenkins installed, also is provisioned to build and push docker images, and connect to webworkes (keys injection). Webworker, besides installing docker, is provisioned with DNS configuration for docker swarm and public key for deploy access, after that single-node docker swarm server is stared. Both instances have AWS CLI installed and configured with credentials provided during provisioning. AWS CLI is used for ECR access and webworkers private IP discovery.

Hosted app repository: https://github.com/McOffsky/rusk_webservice

#### HOW TO RUN IT?

Requirements:
- Terraform
- Ansible

If you dont have either of those installed, run `make dev-env` or install them manually.

1. Create `terraform.tfvars` (this file wont be added to git)
```
aws_access_key = "xxx"
aws_secret_key = "xxx"
aws_region = "eu-central-1"
```

2. Create `vars.json` (this file wont be added to git)
```
{
    "aws_access_key": "xxx",
    "aws_secret_key": "xxx",
    "aws_region": "eu-central-1",

    "jenkins_admin_user": "admin",
    "jenkins_admin_password": "admin"
}
```
3. Run command `make it-fly`. This command will execute `terraform apply`, after that it will wait 30s for all changes to propagate, and it will start provisioning machines. During the provisioning first it will recreate `.ansible/inventory` and then it will execute `playbook.yml` with key downloaded from cluster.

4. Go to your AWS console and check public access adresses for both instances. Jenkins will be accessible on `http://<rusk_jenkins1 public dns>:8080`, with login and password defined in `vars.json` file. Rusk app webservice will be accessible on `http://<rusk_web1 public dns>:80/jokes`, the only supported path is `/jokes`, which will show 100 latest entries from `bash.org.pl`.

For additional `make` commands, check `make help`