pipeline {

    agent {
      label params.AGENT == "any" ? "" : params.AGENT
    }
    options {
        ansiColor('xterm')
    }
    //jenkins-plugin-cli --plugins ansicolor:1.0.4

    environment {
       UNCM_PROFILE = 'test'
       //UZDO_PROFILE = 'test'
       BITBUCKET_COMMON_CREDS = credentials('GIT_CREDENTIALS')
       DOCKER_CREDENTIALS = credentials('NEXUS_CREDENTIAL_ID')
       ZETA_CREDENTIALS = credentials('ZETA_CREDENTIALS')
       SSH_CREDENTIALS = credentials('SSH_CREDENTIALS')
       GIT_URL = '10.195.44.19:7990/scm/uncm/ru.tii.uncm.git'
       ZETA = 'http://10.195.44.168:9200'
       NEXUS_VERSION = "nexus3"
      // PROTOCOL = "http"
       TZ="Europe/Moscow"
        //NEXUS_URL = "vacuum-registry.digital.interrao.ru"

        //NEXUS_REPOSITORY = "http://10.195.44.217:8081/repository/vacuum_registry/"
        //zeta - http://10.195.44.168:9280/repository/plugins.gradle.org-proxy/

    }

    parameters {
        choice(name: "AGENT", choices: ["any", "dev", "test", "docker"])
    }

    stages {

        stage('Prepare') {
            steps {
              script {
                echo "NODE_NAME = ${env.NODE_NAME}"
                echo "${env.WORKSPACE}"
                sh 'docker logout  https://index.docker.io/v1/'
                sh 'docker logout  https://index.docker.io/v2/'
                sh 'docker logout  https://registry-1.docker.io/v2/'
                sh 'docker logout  hub.docker.com'
                sh 'rm -rf ~/.ssh'
                sh 'rm -rf ru.tii.uncm || echo "Err $?"'
                sh 'git clone -b master "$PROTOCOL://$BITBUCKET_COMMON_CREDS_USR:$BITBUCKET_COMMON_CREDS_PSW@$GIT_URL"'
                dir('ru.tii.uncm') {
                    sh 'git branch -a'
                    sh 'git fetch'
                    sh 'git pull'
                  }

                try {
                    sh '''
                    echo "Check zeta"
                    curl -u "${ZETA_CREDENTIALS_USR}:${ZETA_CREDENTIALS_PSW}" -fsSLZX GET "zeta:9280/service/rest/v1/search?repository=plugins.gradle.org-proxy" | wc -l
                    '''
                }
                catch(err){
                  echo "Caught: ${err}"
                  currentBuild.result = 'FAILURE'
                }
                finally{
                    sh 'echo default finally'
                }
                //add data to daemon.json
                //sh 'cat /etc/docker/daemon.json'
                //git config --global user.name "dyagovkin"
                //git config --global user.email dyagovkin@sigma-it.ru
              }
            }
            post {
              always {
                  script{
                       sh '''
                         export TZ="Europe/Moscow"
                         date
                       '''
                  }
              }
              success {
                sh 'echo "Only Success"'
              }
            }
          }

        stage('Docker') {
            steps {

              script {
                try {
                echo "Check Docker Socket & more ..."
                sh 'curl -fsSLZX GET --unix-socket /run/docker.sock http://localhost/version'
                echo "Docker login & show data in registry"
                sh '''
                  echo "$DOCKER_CREDENTIALS_PSW"| docker login --username admin --password-stdin vacuum-registry.digital.interrao.ru
                  curl -kfsSLZX GET https://vacuum-registry.digital.interrao.ru/v2/_catalog
                  curl -kfsSLZX GET https://vacuum-registry.digital.interrao.ru/v2/repository/vacuum_registry/apiservice/tags/list
                '''
                }
                catch(err) {
                  echo "Caught: ${err}"
                  currentBuild.result = 'FAILURE'
                }
                finally {
                    sh 'echo "finally"'
                }
              }
            }
            post {
              always {
                echo "NODE_NAME = ${env.NODE_NAME}"
              }
              success {
                echo "Only Success"
              }
            }
          }

        stage('Build') {
            steps {
              script {
                try {
                  dir('ru.tii.uncm') {
                    dir('services') {
                       sshagent(['SSH_CREDENTIALS']) {
                       ansiColor('xterm') {
                       sh("sed -i  's#../uzdo#uzdo#g' ./uadm/0deploytest.sh")
                       sh("sed -i  's#../uzdo#uzdo#g' ./config/0deploytest.sh")
                       sh("sed -i  's#/app#app#g' ./pgsql/run.sh")
                       sh("sed -i  's#host-docker#10.195.44.217#g' ./pgsql/run.sh")
                       sh("sed -i  's#services:#version: \"3\"\\nservices:#g' ./pgsql/docker-compose.yml")
                       //add to /etc/hosts
                       //10.195.44.217   nexus
                       //10.195.44.217   host-docker
                       //10.195.44.217   vacuum-registry.digital.interrao.ru
                       //10.195.44.19    bitbucket
                       //10.195.44.168   zeta
                       sh '''
                         [ -d ~/.ssh ] || mkdir ~/.ssh && chmod 0700 ~/.ssh
                         ssh-keyscan -t rsa,dsa host-docker >> ~/.ssh/known_hosts
                         ssh ucm@host-docker "hostname"
                         echo '\033[34mPREPARE\033[0m \033[33mCHECK\033[0m \033[35mand more ...\033[0m'
                         echo "PWD=\\`pwd\\`\nIMAGE=\\`basename \\${PWD}\\`" > preparedeploy.sh
                         echo '\033[34mBUILD\033[0m \033[33mCHECK\033[0m \033[35mand more ...\033[0m'
                         echo "find .  -mindepth 2 -name '*build.sh' -type f -executable -print0 \\
                         | sort -z -t/ -k3,3 | xargs -0 -I '{}' sh -c 'echo Running {} && cd \\`dirname {}\\` \\
                         && pwd && ../preparedeploy.sh && ./\\`basename {}\\`'" > build.sh
                         sh ./build.sh
                         echo '\033[34mDEPLOY\033[0m \033[33mCHECK\033[0m \033[35mand more ...\033[0m'
                         cp ../dbms/create_db.sh ./pgsql

                         sed -i '16 i dbhost="10.195.44.217"' ./pgsql/create_db.sh
                         sed -i '17 i dbport="5433"' ./pgsql/create_db.sh
                         sed -i '18 i dbname="pg_uncm"' ./pgsql/create_db.sh
                         sh ./deploytest.sh
                       '''
                       dir("${env.WORKSPACE}") {
                           sh 'ls -la && pwd'
                             //add your creds by bitbucket or something ... !!!
                             //HERE git clone your submodules & change dir of servise & ./gradlew build docker -x test & check

                       }
                       }
                     }

                    }
                  }
                }
                catch(err){
                  echo "Caught: ${err}"
                  currentBuild.result = 'FAILURE'
                }
                finally{
                    sh 'echo "Default finally block .........."'
                }
              }
            }
           post {
             success {
               echo "Build is Suck_yes"
             }
            always {
                echo "NODE_NAME = ${env.NODE_NAME}"

            }
        }
      }
//Other Stuff & more
    }

    //post {
        //always {
            //node('built-in'){
             // echo "NODE_NAME = ${env.NODE_NAME}"
            //}
      //  }
//        changed {
//            sh 'echo changed'
//        }
//        cleanup {
//            sh 'echo cleanup'
//        }
    //}

}
