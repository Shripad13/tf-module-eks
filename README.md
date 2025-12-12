# tf-module-eks
This is the backend module for expense-terraform-eks
>All the code, needed to create EKS will be hosted here.

EKS = Elastic Kuberentes Service
EKS is a managed service for k8s (PaaS)

# How to supply the attributes from one module to another modules?
We cannot communicate 2 tf modules in directly.
From one Module output will send to root module, Through root module we supply input to another module.

# What all info is needed by EKS from VPC?
1. vpc_id
2. lb subnet_ids 
3. eks subnet_ids
4. db subnet_ids


# Right Now Our databse is selfManaged & reponsible for -
high availability (replication software)
server maintainance
response time
storage management 
scalability
Backup & management

# If we go with Manged Service, AWS offers Sequel DB as a service (PaS), RDS-

RDS - Relational Database Service
 - SQL DB
 - MYSQL DB
 - Maria DB
 - Aurora MySQL DB - EC2 linux
 - Aurora Postgress
 - Postgress
 - IBM DB2
 - Oracle

 famous DB replication software comes with huge cost.
 stateless workloads (Non-Data) on cloud
 DB related work on On-Premise

 # RDS
 1. you can create the cluster either in instance mode or cluster Mode
 2. In training, will go with instance mode.
 3. In corporate CLuster mode DB will be setup.
 4. In CLuster mode there will be 1 write DB alongwith 2 read only DB.
 5. In cluster mode, Cost also increases as per DB.
 6. In Instance mode there will be main DB & replica DB, so continuously Main DB will be writing if in case of failover replica DB will take the workload.
 7. In instance mode, main DB & replica DB will be in different zones.