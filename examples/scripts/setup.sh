#!/bin/bash

# Install AWS client
python3 -m pip install awscli

# Wait for the count to be up
while [[ $(aws ec2 describe-instances --region us-east-1 --filters "Name=tag:selector,Values=${selector_name}-selector" | jq .Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddresses[].PrivateDnsName | wc -l) -ne ${desired_size} ]]
do
   echo "Desired count not reached, sleeping."
   sleep 10
done
found_count=$(aws ec2 describe-instances --region us-east-1 --filters "Name=tag:selector,Values=${selector_name}-selector" | jq .Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddress | wc -l)
echo "Desired count $found_count is reached"

# Update the config files with our hosts - we need the ones from hostname
hosts=$(aws ec2 describe-instances --region us-east-1 --filters "Name=tag:selector,Values=${selector_name}-selector" | jq -r .Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddresses[].PrivateDnsName)

# Write them into /etc/hosts
NODELIST=""
for host in $hosts; do
   if [[ "$NODELIST" == "" ]]; then
      NODELIST=$host
   else
      NODELIST=$NODELIST,$host   
   fi
done

# Write hostlist somewhere we can find it
sudo echo $NODELIST >> /opt/hostlist.txt
