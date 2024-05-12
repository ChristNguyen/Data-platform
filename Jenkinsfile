// pipeline {
//     agent any

//     environment {
//         DOCKER_IMAGE = "dga-ae-trino"
//         PROJECT_NAME = "dp"
//         GIT_COMMIT_HASH = sh(script: "printf \$(git log -n 1 --pretty=format:'%H' | cut -c 1-8 )", returnStdout: true)
//     }

//     stages {
//         stage('Build') {
//             environment {
//                 DOCKER_REGISTRY_PROTOCOL = "https"
//                 DOCKER_REGISTRY = "nexus-docker.df.msb.com.vn"
//                 DOCKER_REGISTRY_CREDENTIALS = "dso-docker-dev-rw"
//                 DOCKER_TAG = "${GIT_COMMIT_HASH}"
//                 ENV_NAME = "dev"
//             }

//             steps {
//                 script {
//                     docker.withRegistry("${DOCKER_REGISTRY_PROTOCOL}://${DOCKER_REGISTRY}", DOCKER_REGISTRY_CREDENTIALS) {
//                         image = docker.build(
//                             "${DOCKER_REGISTRY}/${PROJECT_NAME}/${ENV_NAME}/${DOCKER_IMAGE}:${DOCKER_TAG}",
//                             "-f Dockerfile ."
//                         )
//                         image.push("${DOCKER_TAG}")
//                         image.push("${ENV_NAME}")
//                     }
//                 }
//             }
//         }
//     }
// }

my_node = k8sagent(name: 'base')
podTemplate(my_node) {
    node(my_node.label) {
        stage("Checkout SCM") {
            checkout scm
        }

        stage("Build Docker Image") {
            def props = {}
            props.DOCKER_REGISTRY_DSO = "docker-dso.msb.com.vn"  // for pull images
            props.DOCKER_REGISTRY = "docker-nonprod.msb.com.vn"  // for push to non-prod
            props.DOCKER_REGISTRY_CREDENTIALS = "dso-docker-non-prod"
            props.PROJECT_NAME = "dp"
            props.ENV_NAME = "dev"
            props.SERVICE_NAME = "dga-ae-trino"
            props.GIT_COMMIT_HASH = sh(script: "printf \$(git log -n 1 --pretty=format:'%H' | cut -c 1-8)", returnStdout: true)
            withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: props.DOCKER_REGISTRY_CREDENTIALS, usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASSWD']]) {
                container(name: 'docker-client'){
                    sh """
                        sleep 5
                        docker login -u $NEXUS_USER -p $NEXUS_PASSWD ${props.DOCKER_REGISTRY_DSO}
                        docker build . -t ${props.DOCKER_REGISTRY}/${props.PROJECT_NAME}/${props.ENV_NAME}/${props.SERVICE_NAME}:${props.GIT_COMMIT_HASH}
                        sleep 5
                        docker login -u $NEXUS_USER -p $NEXUS_PASSWD ${props.DOCKER_REGISTRY}
                        docker push ${props.DOCKER_REGISTRY}/${props.PROJECT_NAME}/${props.ENV_NAME}/${props.SERVICE_NAME}:${props.GIT_COMMIT_HASH}
                    """
                }
            }
        }
    }
}

