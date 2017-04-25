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
       stringParam('myParameterName0', 'my default stringParam value', 'my description')
       stringParam('myParameterName1', 'my default stringParam value', 'my description')
       stringParam('myParameterName2', 'my default stringParam value', 'my description')
       stringParam('myParameterName3', 'my default stringParam value', 'my description')
       stringParam('myParameterName4', 'my default stringParam value', 'my description')
       
    }
}
