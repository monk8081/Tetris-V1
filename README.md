# DevSecOps pipeline is quite comprehensive, covering infrastructure provisioning with Terraform, Jenkins for CI/CD, and deploying applications to EKS using ArgoCD.

## Step 1: Provisioning an EC2 Instance with Terraform
In this initial step, you utilize Terraform to automatically provision an EC2 instance on AWS. This instance serves as the foundation for your DevSecOps pipeline, where Jenkins, SonarQube, Trivy, kubectl, AWS CLI, and Terraform are installed. This automated infrastructure setup ensures that you have a clean environment for subsequent DevOps activities.

## Step 2: Installing Jenkins, SonarQube, Trivy, kubectl, AWS CLI, and Terraform
Upon the successful launch of the EC2 instance, you proceed to automatically install and configure essential DevSecOps tools and utilities. Jenkins serves as the heart of your CI/CD pipeline, SonarQube for code quality checks, Trivy for vulnerability scanning, kubectl for Kubernetes management, AWS CLI for AWS resource management, and Terraform for infrastructure as code. The automated installation of these tools guarantees a standardized and reproducible environment.

## Step 3: Setting Up Jenkins Pipelines
With Jenkins up and running, you configure pipelines to automate the end-to-end CI/CD process. The pipelines are responsible for orchestrating the entire workflow, from provisioning AWS EKS clusters with Terraform to deploying applications to EKS with ArgoCD. These pipelines ensure consistency and efficiency in your DevOps practices.

## Step 4: Provisioning EKS Clusters with Terraform (First Job)
The first job in your Jenkins pipeline involves provisioning AWS EKS clusters using Terraform. This step ensures that your Kubernetes environment is automatically established in a controlled and repeatable manner. Infrastructure as code principles ensure that the infrastructure setup is version-controlled and easily replicable.

## Step 5: Building and Deploying the First Version of the Game
Once your EKS cluster is in place, the pipeline proceeds to build the first version of your Tetris game. Jenkins automates the build process, ensuring that the application is packaged correctly. Subsequently, the game is deployed to the EKS cluster, making it accessible to users. This automation accelerates the delivery of your applications while maintaining consistency and reliability.

## Step 6: Deploying Another Version to ArgoCD
As part of your continuous delivery pipeline, you deploy another version of the Tetris game to ArgoCD. ArgoCD automates the deployment to your EKS cluster by detecting changes in the Git repository. This step demonstrates full automation, where updates to the application are automatically propagated to the Kubernetes cluster without manual intervention.

## Step 7: Automated Image Updates via Jenkins CI/CD
One of the core principles of DevOps is automation, and Jenkins handles this seamlessly. Updates to the Tetris game's Docker image are managed exclusively through Jenkins CI/CD. Jenkins ensures that the image updates are applied to the Kubernetes deployment files, further highlighting the end-to-end automation in your pipeline


# React Tetris V1

Tetris game built with React

<h1 align="center">
  <img alt="React tetris " title="#React tetris desktop" src="./images/game.jpg" />
</h1>


Use Sonarqube block 
```
environment {
        SCANNER_HOME=tool 'sonar-scanner'
      }

stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Amazon \
                    -Dsonar.projectKey=Amazon '''
                }
            }
        }
```        

Owasp block
```
stage('OWASP FS SCAN') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
```

# ARGO CD SETUP
https://archive.eksworkshop.com/intermediate/290_argocd/install/

# Image updater stage
```
 environment {
    GIT_REPO_NAME = "Tetris-manifest"
    GIT_USER_NAME = "monk8081"
  }
    stage('Checkout Code') {
      steps {
        git branch: 'main', url: 'https://github.com/monk8081/Tetris-manifest.git'
      }
    }

    stage('Update Deployment File') {
      steps {
        script {
          withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
            // Determine the image name dynamically based on your versioning strategy
            NEW_IMAGE_NAME = "mmaurya694/tetrisv2:latest"

            // Replace the image name in the deployment.yaml file
            sh "sed -i 's|image: .*|image: $NEW_IMAGE_NAME|' deployment.yml"

            // Git commands to stage, commit, and push the changes
            sh 'git add deployment.yml'
            sh "git commit -m 'Update deployment image to $NEW_IMAGE_NAME'"
            sh "git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main"
          }
        }
      }
    }

```
