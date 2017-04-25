pipelineJob('Capians_deploy') {
      definition {
        cpsScm {
            scm {
              git {
                remote {
                 name('origin') 
                 url('https://github.com/maxkrukov/capians.git')
                }
                 branch('master')
                 extensions {wipeOutWorkspace()}                 
                }
              
            }
        }
    }
     parameters {
        credentialsParam('credsID') {
            type('com.cloudbees.jenkins.plugins.sshcredentials.impl.UsernamePasswordCredentialsImpl')
            required()
            defaultValue('')
            description('SSH user and password for ansible')
        }

       choiceParam('action', ['deploy', 'rollback'])
       booleanParam('testing', false, 'check to disable tests')
       stringParam('deploy_to', '/tmp/test', 'path to deploy into')
       stringParam('git_method', 'https', 'https or ssh')
       stringParam('git_repo', '', 'git repo url')
       stringParam('git_user', '', 'git user name is needed for https only')
       stringParam('git_pass', '', 'git pass name is needed for https only')
       stringParam('git_key', '', 'path to rsa_key is needed for ssh only')
       stringParam('git_branch', '', '')
       stringParam('keep_releases', '5', '')
       textParam('hosts', '
[hosts]
host1
host2 ansible_ssh_host=45.45.45.45 ansible_ssh_port=2222
                            ', 'nodes to deploy')
              
    }
}
