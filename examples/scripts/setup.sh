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

# Extra sleep for good measure lol
sleep 10

# Update the config files with our hosts - we need the ones from hostname
wget https://gist.githubusercontent.com/vsoch/275b865921605e54ab48087e8036dae2/raw/bb7c663abf8cd3f016847fdf668a7a241c768b27/write-hostlist.sh
chmod +x write-hostlist.sh
./write-hostlist.sh $selector_name-selector
