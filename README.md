# Cloud Coding Exercise: Containerized Web App on GCP

The project consists of two main components:

1.  Infrastructure (Terraform): Deploys the necessary GCP resources.
2.  Application (FastAPI): A simple Python web service that connects to a Cloud SQL database.

Infrastructure Components

The following resources are provisioned by Terraform:

VPC Network
Subnet: A single subnet 
Firewall Rules:
    *   Allows HTTP traffic (port 80) from the internet to the web server.
    *   Allows SSH access (port 22) exclusively from Google's secure Identity-Aware Proxy (IAP) service, preventing direct exposure of the SSH port to the public internet.
Cloud SQL for MySQL
Google Compute Engine (GCE)


Application

The application is a lightweight API built with FastAPI.

It provides a single endpoint (`/`) that connects to the Cloud SQL database, queries a table named `housesFree`, and displays the results.
The application is packaged into a*Docker container.
The application is configured to read database credentials (host, user, password, database name) from environment variables, which are securely passed to the container by the startup script at runtime.

Deployment:

1.  Clone the Repository

2.  Add the proper Terraform state backend



3.  Set Database Password: Set the database password as an environment variable. Terraform will automatically use it.

    export TF_VAR_db_password="your-secure-password"
 

5.  Init and Terraform apply:


How to Test


After `terraform apply` completes, it will output the public IP address of the web instance.
Create the DB table in the Cloud SQL and add some information
    curl http://<your_instance_ip>
  
The project right now is running and you can test it with:  curl http://35.222.135.93 






Things to improve:
Better comments in code, maybe create a tf module but for this simple test wouldn't be necessary.

Save the DB password in another solution, maybe in secret manager or vault