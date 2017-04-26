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
            script(readFileFromWorkspace('Jenkinsfile'))
        }
    }
     parameters {
        credentialsParam('credsID') {
            type('com.cloudbees.jenkins.plugins.sshcredentials.impl.UsernamePasswordCredentialsImpl')
            required()
            defaultValue('')
            description('SSH user and password for ansible')
        }

       choiceParam('action', ['deploy', 'rollback'], '')
       booleanParam('testing', false, 'check to enable tests')
       stringParam('deploy_to', '/tmp/test', 'path to deploy into')
       stringParam('git_method', 'https', 'https or ssh')
       stringParam('git_repo', '', 'git repo url')
       stringParam('git_user', '', 'git user name is needed for https only')
       stringParam('git_pass', '', 'git pass name is needed for https only')
       stringParam('git_key', '', 'path to rsa_key is needed for ssh only')
       stringParam('git_branch', '', '')
       stringParam('keep_releases', '5', '')

       textParam('hosts', '''[hosts]
host1
host2 ansible_ssh_host=45.45.45.45 ansible_ssh_port=2222
                            ''', 'nodes to deploy')

       textParam('vars', '''var1: value1
var2: value2
var3: value3
                            ''', 'template vars')

       textParam('templates', '''src1 dest1;
src2 dest2;
                            ''', 'templates: source dest;')
              
       textParam('deploy_pre_symlink', '''chmod 775 -R \$1
chown apache:apache -R \$1
                            ''', '\$1 - release path; \$2 - deploy_to path')

       textParam('deploy_after_symlink', '''
                            ''', '\$1 - release path; \$2 - deploy_to path')

       textParam('rollback_pre_symlink', '''
                            ''', '\$1 - release path; \$2 - deploy_to path')

       textParam('rollback_after_symlink', '''
                            ''', '\$1 - release path; \$2 - deploy_to path')

       textParam('deploy_pre_symlink_once', '''
                            ''', '\$1 - release path; \$2 - deploy_to path')

       textParam('deploy_after_symlink_once', '''
                            ''', '\$1 - release path; \$2 - deploy_to path')

       textParam('rollback_pre_symlink_once', '''
                            ''', '\$1 - release path; \$2 - deploy_to path')

       textParam('rollback_after_symlink_once', '''
                            ''', '\$1 - release path; \$2 - deploy_to path')

       stringParam('domain', '', 'http(s)://domain.com or domain.com')

       textParam('test_script', '''
                            ''', '')


       stringParam('test_ip', '', '')
       stringParam('test_port', '', '')
       stringParam('token', '', 'TELEGRAM')
       stringParam('chat_id', '', 'TELEGRAM')

    }
}
