#AWS Provider variables
profile="default"
aws_region="us-east-1"
key_name= {us-east-1 = "your-keypair",}
owner_tag_name="youremail@uipath.com"

##### EC2 Orchestrator instances #####
aws_app_instance_type="t2.medium"
admin_password="YOURPASSWORD"
orchestrator_password="YOURPASSWORD"
orchestrator_passphrase="YOURPASSWORD"
orchestrator_license="1111-1111-1111-1111"
orchestrator_versions="19.10.15"

##### HAA instances #####
haa-user="youremail@uipath.com"
haa-password="YOURPASSWORD"
haa-license="353tgewsdfweg34t342rftg23g2g23t2r32r2353tgewsdfweg34t34"

##### AWS RDS SQL instances #####
newSQL="yes"
db_username="uipath_sql"
db_password="YOURPASSWORD"
db_name="awstest"
sql_srv="awdevstest.database.com"
rds_allocated_storage="100"
rds_instance_class="db.m4.large"
rds_multi_az="false"
skip_final_snapshot="true"

##### Orchestrator values #####
environment="dev"
application="uipath_orchestratorstack"
role="s3pol"
s3BucketName="yours3bucket"
instance_count=2

##### VPC and LB values #####
domain="YOURDOMAIN.com"
subdomain="elb"
certificate_arn="arn:aws:acm:us-east-1:338284260280:certificate/d27c1073-e092-4b58-be98-6d30c5a459d3"
associate_public_ip_address="false"
cidr_block="10.0.0.0/16"
security_cidr_block="0.0.0.0/0"