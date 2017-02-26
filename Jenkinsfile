node {
    //https://github.com/maxkrukov/capians.git
    
    step([$class: 'WsCleanup'])
	currentBuild.displayName = ('#' + env.BUILD_NUMBER + ' ' + action )
	currentBuild.description = "Code Deployment"
    
    stage('Loading configs') {
     git branch: 'stable1.0', url: 'https://github.com/maxkrukov/capians.git' 
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
