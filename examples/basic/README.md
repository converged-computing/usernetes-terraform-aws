# Basic Usernetes

See the main [../../README.md](README.md) for instructions. This hasn't been
setup yet so hostnames are seen - we need to get metadata and add to /etc/hosts
or similar.

## Developer

### AMIs

The following AMIs have been used at some point in this project:

  - `ami-0a71a4436084046bc`: current AMI, with running rootless docker install 
  - `ami-0fd94d7228a016b65`: original AMI, without running rootless docker install

### Credentials

The best practice approach for giving the instances ability to list images (and get the hostnames)
is with an IAM role. However, we used a previous approach to add credentials (scoped) directly to
the environment in the startscript. That looked like this:

Since we want to get hosts on the instance using the aws client, export your credentials to the environment
for the instances:

```bash
export TF_VAR_aws_secret=$AWS_SECRET_ACCESS_KEY 
export TF_VAR_aws_key=$AWS_ACCESS_KEY_ID 
export TF_VAR_aws_session=$AWS_SESSION_TOKEN 
```
