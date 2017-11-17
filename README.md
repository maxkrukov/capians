# capians
Tool for deployment (deploy & rollback) via git (https or ssh).

## **Links**
- [About](https://github.com/maxkrukov/capians/tree/master#about)
- [How to test](https://github.com/maxkrukov/capians/tree/master#how-to-test)
  - [vagrant testing on local machine](https://github.com/maxkrukov/capians/blob/master/README.md#console-usage)
  - [jenkins testing]()
- [console usage](https://github.com/maxkrukov/capians/blob/master/README.md#console-usage)
  - [Requirements](https://github.com/maxkrukov/capians/tree/master#requirements)
  - [Custom tasks](https://github.com/maxkrukov/capians/tree/master#custom-tasks)
- [Jenkins integration with telegram massaging]()  
  - [About](https://github.com/maxkrukov/capians/tree/master#about-1)
  - [Requirements](https://github.com/maxkrukov/capians/tree/master#requirements-1)


## About
It is based on ansible with capistrano3 algorithm.
It keeps git repo in bare form. So it saves time 
especially using a large repos. Optionally it is integrated with jenkins
with Telegram massaging.

## **How to test**

# Console usage

## Requirements
- *ansible 2.3.0.0*
- *Vagrant 1.8.1*
- *virtualbox 4.3 or higher*

You need to install ansible, vagrant and virtualbox
```
yum install -y git ansible vagrant virtualbox
```
or
```
apt install -y git ansible vagrant virtualbox
```
##### continue
```
git clone https://github.com/maxkrukov/capians.git
cd ./capians
vagrant up
cp vars.example vars  # Set your vars into it
```
##### To deploy:
```
ansible-playbook deploy.yml 
```
##### To rollback:
```
ansible-playbook deploy.yml -e "act=rollback"
```
## Custom tasks

You can also configure templates, {pre,after}-symlink tasks for deploy/rollback .
Configure files located in roles/{deploy/rollback}/tasks/custom/ .
It has ansible [yaml syntax](http://docs.ansible.com/ansible/list_of_all_modules.html).




# Jenkins integration with telegram massaging

## About
It is very simple tool for deploy, rollback, testing based on ansible and jenkins. Job is fully parameterized. 
You need to run [jenkins.dsl script](https://github.com/maxkrukov/capians/blob/master/jenkins.dsl) to configure job structure. Then set all parameters for your environment.
Instruction will be provided below soon.


## Requirements
- *ansible 2.4.1.0*
- *jenkins 2.40 or higher*
   - install suggested plugins
   - [*Ansible Plugin*](https://wiki.jenkins-ci.org/display/JENKINS/Ansible+Plugin)
   - [*SSH Agent Plugin*](https://wiki.jenkins-ci.org/display/JENKINS/SSH+Agent+Plugin)
   - [*Job DSL plugin*](https://plugins.jenkins.io/job-dsl)
   - [*build-user-vars-plugin*](https://wiki.jenkins.io/display/JENKINS/Build+User+Vars+Plugin)


