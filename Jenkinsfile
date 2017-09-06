node("${node}") {
    step([$class: 'WsCleanup'])
	currentBuild.displayName = ('#' + env.BUILD_NUMBER + ' ' + action )
	currentBuild.description = "Code Deployment"


  withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: credsID ,
                    usernameVariable: 'test_user', passwordVariable: 'test_pass']]) {
	
  if (domain ==~ /^http.*/){
	env.projectUrl = "${domain}"
  } else {
	env.projectUrl = "http://${git_branch}.${domain}"
  }
////
// Config part
////    
	try {  // Start try_catch
    stage('Loading configs...') {
        git branch: 'master', url: 'https://github.com/maxkrukov/capians.git' 
     
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
              dest: \\\"{{capians_release_path.stdout}}/`echo $line | awk \'{print$2}\'`\\\" "
                   done >> roles/deploy/tasks/custom/template.yml'''
      
      writeFile file: 'roles/deploy/tasks/custom/pre_symlink.sh', text: ('set -o pipefail; ' +  ' cd $1 ; ' + 'hostname; set -ex; ' + deploy_pre_symlink)
      writeFile file: 'roles/deploy/tasks/custom/after_symlink.sh', text: ('set -o pipefail; ' +  ' cd $1 ; ' + 'hostname; set -ex; ' + deploy_after_symlink)
      writeFile file: 'roles/rollback/tasks/custom/pre_symlink.sh', text: ('set -o pipefail; ' +  ' cd $1 ; ' + 'hostname; set -ex; ' + rollback_pre_symlink)
      writeFile file: 'roles/rollback/tasks/custom/after_symlink.sh', text: ('set -o pipefail; ' +  ' cd $1 ; ' + 'hostname; set -ex; ' + rollback_after_symlink)
    
      writeFile file: 'roles/deploy/tasks/custom/pre_symlink_once.sh', text: ('set -o pipefail; ' +  ' cd $1 ; ' + 'hostname; set -ex; ' + deploy_pre_symlink_once)
      writeFile file: 'roles/deploy/tasks/custom/after_symlink_once.sh', text: ('set -o pipefail; ' +  ' cd $1 ; ' + 'hostname; set -ex; ' + deploy_after_symlink_once)
      writeFile file: 'roles/rollback/tasks/custom/pre_symlink_once.sh', text: ('set -o pipefail; ' +  ' cd $1 ; ' + 'hostname; set -ex; ' + rollback_pre_symlink_once)
      writeFile file: 'roles/rollback/tasks/custom/after_symlink_once.sh', text: ('set -o pipefail; ' +  ' cd $1 ; ' + 'hostname; set -ex; ' + rollback_after_symlink_once)
    
      writeFile file: 'vars', text: vars
    }

////
// Deploy part
/// 
    stage('Deploying...') {
        ansiblePlaybook colorized: false, 
            credentialsId: credsID, 
            playbook: 'deploy.yml', 
            sudo: true, 
            extraVars: [
                act: action,
		git_method: git_method,
                deploy_to: deploy_to,
                git_repo: git_repo,
                git_user: git_user,
                git_pass: [value: git_pass, hidden: true],
                git_branch: git_branch,
                keep_releases: keep_releases,
		git_key: git_key
            ]
    }

////
// Testing
////
       stage('Testing...') {

if( testing=="true" ){

   sshagent(credentials: [""], ignoreMissing: true) {
	   def testing = sh(returnStdout: true, script:'''sshpass -p ${test_pass} ssh -o StrictHostKeyChecking=no -p ${test_port} -l ${test_user} ${test_ip}  "
      hostname ; set -xe 
       cd  ${deploy_to}/current
         ${test_script} 
           " 2>&1 || echo "That_was_failed" ''').trim() 

   println(testing)
   writeFile file: "result_${BUILD_NUMBER}.txt", text: testing
   sh('if (cat result_${BUILD_NUMBER}.txt | egrep "That_was_failed$") ; then false ; fi ')
   }
} else { println('Skipping...') }

       }

////
// Massage part
////

    stage('Sending msg via Telegram') {

  def buildStatus = 'Success'
	    
  def subject = """${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'
############################
"""

  def action = action
  
  def user_build =  sh(returnStdout: true, script:"""#!/bin/bash
      a=\$(echo '/${JOB_NAME}' | sed 's|/|/jobs/|g')
      logfile=`echo ${JENKINS_HOME}/\$a/builds/${BUILD_NUMBER}/log`
      grep -i Started \$logfile | sed -e \"s|.*\\[0m|Deployed by: |g\" 
      """).trim()

  def details = """Build Action: ${action} 
${user_build}
BUILD URL: ${env.BUILD_URL}console
Project URL: ${env.projectUrl}
Testing: $testing
""" 

  env.MSG = (subject + details)
  
sh ''' for i in `echo ${chat_id} | sed "s/,/  /g"` ; do
   curl  -s --max-time 10 -F chat_id=${i} -F disable_web_page_preview=1 -F "text=${MSG}"  https://api.telegram.org/bot${token}/sendMessage
     if [ -f result_${BUILD_NUMBER}.txt ] ; then
   curl  -s --max-time 10 -F chat_id=${i} -F document=@result_${BUILD_NUMBER}.txt  -F "caption=Job ${JOB_NAME} [${BUILD_NUMBER}]"  https://api.telegram.org/bot${token}/sendDocument    
     fi
	done '''

    }

////
// End of script
////
// Catch part
////
	} catch (Exception err){


	  def buildStatus = '==> Fail !'

  def subject = """${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'
############################
"""

  def action = action

  def user_build =  sh(returnStdout: true, script:"""#!/bin/bash
      a=\$(echo '/${JOB_NAME}' | sed 's|/|/jobs/|g')
      logfile=`echo ${JENKINS_HOME}/\$a/builds/${BUILD_NUMBER}/log`
      grep -i Started \$logfile | sed -e \"s|.*\\[0m|Deployed by: |g\"
      """).trim()

  def details = """Build Action: ${action}
${user_build}
BUILD URL: ${env.BUILD_URL}console
Project URL: ${env.projectUrl}
Testing: $testing
"""

  env.MSG = (subject + details)

sh ''' for i in `echo ${chat_id} | sed "s/,/  /g"` ; do
   curl  -s --max-time 10 -F chat_id=${i} -F disable_web_page_preview=1 -F "text=${MSG}"  https://api.telegram.org/bot${token}/sendMessage
     if [ -f result_${BUILD_NUMBER}.txt ] ; then
   curl  -s --max-time 10 -F chat_id=${i} -F document=@result_${BUILD_NUMBER}.txt  -F "caption=Job ${JOB_NAME} [${BUILD_NUMBER}]"  https://api.telegram.org/bot${token}/sendDocument
     fi 
        done '''
				error 'Failed'
	} // End try_catch

  }
}

