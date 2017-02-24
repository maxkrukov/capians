# capians
Tool for deployment (deploy & rollback) via git

## About
It is based on ansible with capistrano3 algorithm.
It keeps git repo in bare form. So it is save time 
especially using a large repos.

## How to test
You need to install ansible, vagrant and virtualbox
```
yum install -y git ansible vagrant virtualbox
```
or
```
apt install -y git ansible vagrant virtualbox
```
### continue
```
git clone https://github.com/maxkrukov/capians.git
cd ./capians
vagrant up
cp vars.example vars  # Set your vars into it
```
### To deploy:
```
ansible-playbook deploy.yml 
```
### To rollback:
```
ansible-playbook deploy.yml -e "action=rollback"
```

