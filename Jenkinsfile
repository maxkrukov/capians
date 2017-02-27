node {
    step([$class: 'WsCleanup'])
	currentBuild.displayName = ('#' + env.BUILD_NUMBER + ' ' + action )
	currentBuild.description = "Code Deployment"
    
    stage('Loading configs...') {
        git branch: 'stable1.0', url: 'https://github.com/maxkrukov/capians.git' 
     
        writeFile file: 'hosts', text: hosts

        sh  script: '''echo $templates | grep  \';\' | sed \'s/;/\\n/g\' | grep -v \'^$\' | while read line ; do
          echo  "
          - name: Fetching template !!! `echo $line | awk \'{print$1}\'` !!!
            fetch:
              src:   \\\"{{capians_release_path.stdout}}/`echo $line | awk \'{print$1}\'`\\\"
              dest: \\\"./tmp\\\"
              flat: yes
            run_once: true
          - name: Running template !!! `echo $line | awk \'{print$1}\'` !!!
            template:
              src:   \\\"./tmp\\\"
              dest: \\\"{{capians_release_path.stdout}}/`echo $line | awk \'{print$2}\'` \\\" "
                   done >> roles/deploy/tasks/custom/template.yml'''
      
      writeFile file: 'roles/deploy/tasks/custom/pre_symlink.sh', text: ('set -e; ' +  'set -o pipefail; ' + ' cd $1 ; ' + deploy_pre_symlink)
      writeFile file: 'roles/deploy/tasks/custom/after_symlink.sh', text: ('set -e; ' +  'set -o pipefail; ' + ' cd $1 ; ' + deploy_after_symlink)
      writeFile file: 'roles/rollback/tasks/custom/pre_symlink.sh', text: ('set -e; ' +  'set -o pipefail; ' + ' cd $1 ; ' + rollback_pre_symlink)
      writeFile file: 'roles/rollback/tasks/custom/after_symlink.sh', text: ('set -e; ' +  'set -o pipefail; ' + ' cd $1 ; ' + rollback_after_symlink)
    
      writeFile file: 'roles/deploy/tasks/custom/pre_symlink_once.sh', text: ('set -e; ' +  'set -o pipefail; ' + ' cd $1 ; ' + deploy_pre_symlink_once)
      writeFile file: 'roles/deploy/tasks/custom/after_symlink_once.sh', text: ('set -e; ' +  'set -o pipefail; ' + ' cd $1 ; ' + deploy_after_symlink_once)
      writeFile file: 'roles/rollback/tasks/custom/pre_symlink_once.sh', text: ('set -e; ' +  'set -o pipefail; ' + ' cd $1 ; ' + rollback_pre_symlink_once)
      writeFile file: 'roles/rollback/tasks/custom/after_symlink_once.sh', text: ('set -e; ' +  'set -o pipefail; ' + ' cd $1 ; ' + rollback_after_symlink_once)
    }

    stage('Deploying...') {
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

    stage('Sending msg via Telegram') {

  def buildStatus = 'Success'
  def colorName = 'RED'
  def colorCode = '#FF0000'
  def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
  def summary = "${subject} (${env.BUILD_URL})"
  def action = action
  def email_error = env.capture
  def user_build =  sh(returnStdout: true, script:"""#!/bin/bash
      a=\$(echo '/${JOB_NAME}' | sed 's|/|/jobs/|g')
      logfile=`echo ${JENKINS_HOME}/\$a/builds/${BUILD_NUMBER}/log`
      grep -i Started \$logfile | sed -e \"s|.*\\[0m|Deployed by: |g\" 
      """).trim()
  def details = """<p>Build Action: ${action} </p> <p>${user_build} </p><p>Deploy Status: ${buildStatus}<p>Console: <a href='${env.BUILD_URL}/console'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a></p><p>STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
    <p>Check build running at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>"""

build job: 'Telegram', parameters: [text(name: 'msg', value: subject + details)]

    }

}

