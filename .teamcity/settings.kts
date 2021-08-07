import jetbrains.buildServer.configs.kotlin.v2019_2.*
import jetbrains.buildServer.configs.kotlin.v2019_2.buildSteps.dockerCommand
import jetbrains.buildServer.configs.kotlin.v2019_2.buildSteps.python
import jetbrains.buildServer.configs.kotlin.v2019_2.buildSteps.script
import jetbrains.buildServer.configs.kotlin.v2019_2.projectFeatures.dockerRegistry
import jetbrains.buildServer.configs.kotlin.v2019_2.triggers.finishBuildTrigger
import jetbrains.buildServer.configs.kotlin.v2019_2.vcs.GitVcsRoot

/*
The settings script is an entry point for defining a TeamCity
project hierarchy. The script should contain a single call to the
project() function with a Project instance or an init function as
an argument.
VcsRoots, BuildTypes, Templates, and subprojects can be
registered inside the project using the vcsRoot(), buildType(),
template(), and subProject() methods respectively.
To debug settings scripts in command-line, run the
    mvnDebug org.jetbrains.teamcity:teamcity-configs-maven-plugin:generate
command and attach your debugger to the port 8000.
To debug in IntelliJ Idea, open the 'Maven Projects' tool window (View
-> Tool Windows -> Maven Projects), find the generate task node
(Plugins -> teamcity-configs -> teamcity-configs:generate), the
'Debug' option is available in the context menu for the task.
*/

version = "2021.1"

project {

    vcsRoot(ApplicationSourceCode)

    buildType(ApplicationBuild)
    buildType(AutoDeploy)

    params {
        param("app.version", "1.0.0")
    }

    features {
        dockerRegistry {
            id = "PROJECT_EXT_5"
            name = "Docker Registry"
            url = "https://xinzhao.jfrog.io/"
            userName = "zhaoxin0948@gmail.com"
            password = "credentialsJSON:873b29f8-571c-4cc7-97e4-73e42be8018e"
        }
    }
}

object ApplicationBuild : BuildType({
    name = "ApplicationBuild"
  
    vcs {
        root(ApplicationSourceCode)
    }

    steps {
        dockerCommand {
            name = "Docker Build"
            commandType = build {
                source = file {
                    path = "Dockerfile"
                }
                namesAndTags = "flaskr"
                commandArgs = "--build-arg AWS_ID=${DslContext.getParameter("aws_access_key_id")} --build-arg AWS_KEY=${DslContext.getParameter("aws_access_key")}"
            }
        }
        dockerCommand {
            name = "Docker Tag"
            commandType = other {
                subCommand = "tag"
                commandArgs = "flaskr xinzhao.jfrog.io/product-docker/python-flask-sample-app:${ApplicationSourceCode.paramRefs.buildVcsNumber}"
            }
        }
        python {
            name = "Unit Test"
            enabled = false
            environment = venv {
            }
            command = pytest {
            }
            dockerImage = "flaskr"
            dockerRunParameters = "/bin/sh pip install pytest && pytest"
        }
        dockerCommand {
            name = "Docker Push"
            commandType = push {
                namesAndTags = "xinzhao.jfrog.io/product-docker/python-flask-sample-app:${ApplicationSourceCode.paramRefs.buildVcsNumber}"
            }
            param("dockerfile.path", "Dockerfile")
        }
    }
})

object AutoDeploy : BuildType({
    name = "AutoDeploy"

    params {
        param("k8s.cluster.version", "1.0.9")
    }

    steps {
        script {
            name = "Deploy to AWS"
            scriptContent = """
                #/bin/bash
                helm repo add helm https://xinzhao.jfrog.io/artifactory/helm/
                helm upgrade --install python-flask-sample-app helm/python-flask-sample-app --set image.tag=${ApplicationBuild.depParamRefs["build.vcs.number"]}
                if [ ${'$'}? -eq 0 ]
                then
                	echo "succeed"
                    aws --profile "devops" --region "ap-southeast-2" cloudwatch put-metric-data \
                    --namespace "TeamCityPipeline" \
                    --metric-name "DeployStatus" \
                    --value 0
                else
                    echo "failed"
                    aws --profile "devops" --region "ap-southeast-2" cloudwatch put-metric-data \
                    --namespace "TeamCityPipeline" \
                    --metric-name "DeployStatus" \
                    --value 1
                fi
            """.trimIndent()
            dockerImage = "xinzhao.jfrog.io/product-docker/kopscluster:%k8s.cluster.version%"
        }
        script {
            name = "Send notification to CloudWatch"
            enabled = false
            scriptContent = """
                aws --profile "devops" --region "ap-southeast-2" cloudwatch put-metric-data \
                    --namespace "TeamCityPipeline" \
                    --metric-name "DeployStatus" \
                    --value 0
            """.trimIndent()
        }
    }

    triggers {
        finishBuildTrigger {
            buildType = "${ApplicationBuild.id}"
            successfulOnly = true
        }
    }

    dependencies {
        snapshot(ApplicationBuild) {
            onDependencyFailure = FailureAction.CANCEL
        }
    }
})

object ApplicationSourceCode : GitVcsRoot({
    name = "ApplicationSourceCode"
    url = "https://github.com/xinzhao219/python-flask-sample-app"
    branch = "refs/heads/master"
    authMethod = password {
        userName = "xinzhao219"
        password = "credentialsJSON:31143303-b9ed-4a43-8fc1-d024ae900a9f"
    }
})
