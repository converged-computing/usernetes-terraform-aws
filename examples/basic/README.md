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

### Usage

Change your key in the [main.tf](main.tf) and then bring up the cluster:

```bash
make
```
You'll need to get instance connection strings from the AWS console. And then typically
you need to login as the ubuntu user, and with your pem:

```bash
$ ssh -i "key.pem" -o "IdentitiesOnly=yes" ubuntu@ec2-44-198-52-73.compute-1.amazonaws.com
```

You can look at the startup script logs like this if you need to debug.
 
```bash
$ cat /var/log/cloud-init-output.log
```

Next steps are:

1. Get hostnames / addresses into /etc/hosts
2. Install rootless docker (by the user on startup)
3. Individual commands for control plane / workers to setup usernetes

I started on step 1, but am having trouble just ssh-ing into instances (sometimes I always get permission denied, and then the hostname does not
take). If/when we get that working, we will want to mimic the steps [here](https://github.com/converged-computing/usernetes-terraform-gcp/tree/main/examples/basic). To make things easier we likely want to add logic to the above to define a hostname for the control plane, etc. that is written to each. The main difference in design is that GCP gives predictable hostnames, and aws does not.
