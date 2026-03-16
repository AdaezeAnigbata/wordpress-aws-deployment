# My WordPress Architecture

## How Everything Connects
When someone visits my site, their browser talks to the AWS cloud. Inside AWS, the request hits my Ubuntu EC2 server. Docker is running on that server, and it routes the traffic to my WordPress container. WordPress then talks to the MySQL container to get the website's data, and MySQL saves everything safely onto my attached EBS volume.

User -> EC2 Instance -> Docker -> WordPress Container -> MySQL Container -> EBS Volume

## Why I put the database on an EBS volume
Docker containers are temporary. If I just let MySQL save the data inside the container, and the container crashes or restarts, my whole website (posts, users, everything) would be wiped out. By mapping it to an outside EBS volume, it's like plugging an external hard drive into the container. The data stays safe even if the container goes away.

## Ports and Security
I opened two main ports in my AWS Security Group:
* **Port 80 (HTTP):** So people can actually see and use the website.
* **Port 22 (SSH):** So I can log into the server from my laptop.

**Security Risks:** Right now, port 80 isn't secure (it's not HTTPS), so traffic isn't encrypted. Also, if my port 22 is left open to the entire internet instead of just my personal IP address, random bots could try to guess my password and hack the server.

## What happens if the server crashes right now?
If my EC2 instance crashed right now, the live website would immediately go down. 
* **What would survive:** My actual database records (my posts and users) would survive because they are stored on that separate EBS volume. Also, any backup files I've already sent to my S3 bucket are perfectly safe in the cloud.
* **What would be lost:** Because I only attached the EBS volume to the database, I think any pictures or themes I uploaded straight into the WordPress media folder would be lost if the server itself is completely destroyed. 

## What if I got 100x more users?
I suppose my t3.micro server would probably crash immediately if 100 times more people tried to visit it because it would run out of memory. 
To handle that much traffic, I think I would probably need an AWS Load Balancer and multiple EC2 servers to share the load.