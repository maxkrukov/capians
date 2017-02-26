node {
    step([$class: 'WsCleanup'])
	currentBuild.displayName = ('#' + env.BUILD_NUMBER + ' ' + action )
	currentBuild.description = "Code Deployment"
    
    stage('Loading configs...') {
        git branch: 'stable1.0', url: 'https://github.com/maxkrukov/capians.git' 
     
        writeFile file: 'hosts', text: hosts

        sh returnStdout: true, script: '''echo $templates | grep  \';\' | sed \'s/;/\\n/g\' | grep -v \'^$\' | while read line ; do
          echo  "
          - fetch:
              src:   \\\"{{capians_release_path.stdout}}/`echo $line | awk \'{print$1}\'`\\\"
              dest: \\\"./tmp\\\"
              flat: yes
            run_once: true
          - template:
              src:   \\\"./tmp\\\"
              dest: \\\"{{capians_release_path.stdout}}/`echo $line | awk \'{print$2}\'` \\\" "
                   done >> roles/deploy/tasks/custom/template.yml'''
      
      writeFile file: 'roles/deploy/tasks/custom/pre_symlink.yml', text: pre_symlink
      writeFile file: 'roles/deploy/tasks/custom/after_symlink.yml', text: after_symlink
    }

    stage('Deploying...') {
        writeFile file: 'hosts', text: hosts
        ansiblePlaybook colorized: false, 
            credentialsId: credsID, 
            playbook: 'deploy.yml', 
            sudo: true, 
            extraVars: [
                action: action,
                deploy_to: deploy_to,
                git_repo: git_repo,
                git_user: git_user,
                git_pass: [value: git_pass, hidden: true],
                git_branch: git_branch,
                keep_releases: keep_releases,
                vars: 'empty'
            ]
    }

}
