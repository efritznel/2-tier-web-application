# 2-tier-web-application
# Module vpc
    - Create vpc
    - Internet gateway
    - 2 public subnets in different AZ
    - Public route table and public route
    - Public subnets association
    - 4 private subnets in different AZ

# Module NAT Gateway
    - 2 public IP in different AZ
    - 2 NAT gateway in different AZs in public subnets
    - Private route table for each subnet and add route to each NAT gateway
    - Private subnets association

# Module ALB
    - Apllication Load Balancer in public subnets
    - Target Group
    - Listener on Port 80

# Module Route 53
    - Create public hosted zone for (fritzhomelab.com)

# Module ASG
    - Launch template
    - Autoscaling group
    - Cloudwatch alarm to scale up or down based on CPU utilization
    - config.sh script to install Apache and create the web server

# Module WAF
    - Create the Web Application Firewall

# Module Security-group
    - SG for external ALB (all traffic from Internet on ports 80, 443)
    - SG for web application (only traffic from the ALB SG on port 80)
    - SG for database (only traffic from webapp SG on port 3306)

# Module RDS
    - Create Secret Manager RDS credential
    - Create DB subnet group
    - DB instance

# Module CloudFront
    - Request certificate from ACM (www.fritzhomelab.com)
    - Create a public hosted zone (fritzhomelab.com)
    - Create the CloudFront Distribution with ALB as Origin
    - Attach WAF to the distribution

If your domain is hosted in GoDaddy follow those steps to validate the cert in ACM
Pending validation for ACM follow this:
# Step 1 — Open the certificate in ACM
    - Sign in to Amazon Web Services Console
    - Go to Amazon Certificate Manager
    - Click the Certificate ID for www.fritzhomelab.com
    - Scroll to Domain validation
    - Copy the CNAME Name and CNAME Value
    - Keep this page open

You will see something like:

Field	Example
Name	_abc123.www.fritzhomelab.com
Value	_xyz456.acm-validations.aws

# Step 2 — Log in to GoDaddy
    - Go to GoDaddy
    - Sign in
    - Click My Products
    - Under Domains, click DNS next to fritzhomelab.com

# Step 3 — Add the CNAME record in GoDaddy
    - Click Add New Record
    - Fill the fields exactly as follows:

GoDaddy DNS Form Mapping
GoDaddy Field	What to Enter
Type	CNAME
Name	_abc123.www ← only this part
Value	_xyz456.acm-validations.aws
TTL	1 Hour (default is fine)

# Module Keypair
Create the .pem key pair in AWS 
copy it to your key folder inside modules
run this command to change it from .pem to .pub
    - ssh-keygen -y -f new-keypair.pem > new-keypair.pub
Also copy the .pub key inside your production folder.



