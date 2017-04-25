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
        credentialsParam('DEPLOY_KEY') {
            type('com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey')
            required()
            defaultValue('ssh-key-staging')
            description('SSH Key for deploying build artifacts')
        }
       stringParam('myParameterName0', 'my default stringParam value', 'my description')
       stringParam('myParameterName1', 'my default stringParam value', 'my description')
       stringParam('myParameterName2', 'my default stringParam value', 'my description')
       stringParam('myParameterName3', 'my default stringParam value', 'my description')
       stringParam('myParameterName4', 'my default stringParam value', 'my description')
       
    }
}
