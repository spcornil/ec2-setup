### Basic ssh config constructed using https://linux.die.net/man/5/ssh_config
Host aws-ec2-micro
    HostName ec2-<host-name>.us-west-2.compute.amazonaws.com
    User <username>
    IdentityFile <path-to-key>/<key-name>.pem
