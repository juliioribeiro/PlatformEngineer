## Developer Workflow

Code
Build
Release
Deploy
Monitor


#
1. az login
2. az ad sp create-for-rbac --role="contribuidor" --scope="/subscriptions/"


# Jenkins Installation
```bash
ssh cloud_user@<PUBLIC_IP_ADDRESS>
```
1. Install java-11-openjdk
```bash
sudo yum install -y java-11-openjdk
```
- Install wget and Install the Repo and Key, and Then Install Jenkins
```bash
sudo yum install -y wget
```
Download the repo:
```bash
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
```
Import the required key:
```bash
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
```
Install Jenkins:
```bash
sudo yum install -y jenkins
```
Enable Jenkins:
```bash
sudo systemctl enable jenkins
```
Start Jenkins:
```bash
sudo systemctl start jenkins
```
In a new browser tab, navigate to http://<PUBLIC_IP_ADDRESS>:8080, replacing <PUBLIC_IP_ADDRESS> with the IP address of the cloud server provided on the lab page.

We'll be taken to an Unlock Jenkins page telling us we need to locate the password. In the terminal, run:
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
Copy the result of the command, as this is the password we need.

Paste the password into the Administrator password field on the Jenkins browser page.

Click Continue.

Click Install suggested plugins. Note: If the install of any plugins fails, just wait a moment and click retry.

On the new user creation page, set the following values:

- ername: student
- ssword: OmgPassword!-[Insert some unique characters here]
- ll name: student
- email address:                      
- click save and continue

Click Save and Finish.

Click Start using Jenkins.

Click Manage Jenkins in the left-hand menu, and then look around a bit to get familiar with the items in that area.
