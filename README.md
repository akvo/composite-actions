Docker Composite Actions Documentation
======================================
This comprehensive guide covers the implementation of Akvo's composite actions, a collection of reusable GitHub Actions workflows designed to optimize the CI/CD pipeline. These composite actions offer standardized and tested solutions for essential development operations, including Docker container management, Kubernetes deployments, Node.js tasks, and remote server management via SSH. 

By following this guide, you can integrate these pre-built actions into your workflows, ensuring consistent and reliable deployment practices while minimizing boilerplate code and configuration errors. The composite actions are centrally maintained and version-controlled, enabling seamless updates and standardization across multiple projects.

Table of Contents
-----------------

*   [Docker Operations](#docker-operations)
*   [Kubernetes Operations](#kubernetes-operations)
*   [Node.js Operations](#nodejs-operations)
*   [SSH Operations](#ssh-operations)
*   [How to Implement Composite Actions](#how-to-implement-composite-actions)

Docker Operations
-----------------

### Docker Build Action

**Location**: `.github/actions/docker-build/action.yml`

Builds a Docker image with specified parameters.

#### Inputs:

*   `app-name`: Application name
*   `service-name`: Service name
*   `dockerfile-location`: Location of Dockerfile
*   `cluster-name`: Cluster name

#### Usage Example:

```yaml
- uses: ./composite-actions/.github/actions/docker-build
  with:
    app-name: 'my-app'
    service-name: 'backend'
    dockerfile-location: './src/Dockerfile'
    cluster-name: 'production'
```

### Docker Push Action

**Location**: `.github/actions/docker-push/action.yml`

Pushes a Docker image to Google Container Registry.

#### Inputs:

*   `app-name`: Application name
*   `service-name`: Service name
*   `gcloud-sa`: Google Cloud Service Account credentials
*   `cluster-name`: Cluster name

#### Usage Example:

```yaml
- uses: ./composite-actions/.github/actions/docker-push
  with:
    app-name: 'my-app'
    service-name: 'backend'
    gcloud-sa: ${{ secrets.GCLOUD_SERVICE_ACCOUNT }}
    cluster-name: 'production'
```

Kubernetes Operations
---------------------

### K8S Restart Action

**Location**: `.github/actions/k8s-restart/action.yml`

Restarts a Kubernetes deployment.

#### Inputs:

*   `deployment-name`: Name of the deployment to restart
*   `cluster-name`: Cluster name
*   `gcloud-sa`: Google Cloud Service Account credentials
*   `namespace-name`: Kubernetes namespace

#### Usage Example:

```yaml
- uses: ./composite-actions/.github/actions/k8s-restart
  with:
    deployment-name: 'my-deployment'
    cluster-name: 'production'
    gcloud-sa: ${{ secrets.GCLOUD_SERVICE_ACCOUNT }}
    namespace-name: 'default'
```

### K8S Rollout Action

**Location**: `.github/actions/k8s-rollout/action.yml`

Updates a Kubernetes deployment with a new image version.

#### Inputs:

*   `app-name`: Application name
*   `deployment-name`: Deployment name
*   `cluster-name`: Cluster name
*   `gcloud-sa`: Google Cloud Service Account credentials
*   `namespace-name`: Kubernetes namespace
*   `container-name`: Container name

#### Usage Example:

```yaml
- uses: ./composite-actions/.github/actions/k8s-rollout
  with:
    app-name: 'my-app'
    deployment-name: 'my-deployment'
    cluster-name: 'production'
    gcloud-sa: ${{ secrets.GCLOUD_SERVICE_ACCOUNT }}
    namespace-name: 'default'
    container-name: 'main-container'
```
Node.js Operations
------------------

### Node Operation Action

**Location**: `.github/actions/node-operation/action.yml`

Executes Node.js commands in a containerized environment.

#### Inputs:

*   `node-version`: Node.js version
*   `node-command`: Command to execute

#### Usage Example:

```yaml
- uses: ./composite-actions/.github/actions/node-operation
  with:
    node-version: '18'
    node-command: 'npm run test'
```

### NPM Operation Action

**Location**: `.github/actions/npm-operation/action.yml`

Executes NPM commands in a containerized environment.

#### Inputs:

*   `node-version`: Node.js version
*   `npm-command`: NPM command to execute

#### Usage Example:

```yaml
- uses: ./composite-actions/.github/actions/npm-operation
  with:
    node-version: '18'
    npm-command: 'install --production'
```

### Yarn Operation Action

**Location**: `.github/actions/yarn-operation/action.yml`

Runs Yarn install and build commands.

#### Usage Example:

```yaml
- uses: ./composite-actions/.github/actions/yarn-operation
```


SSH Operations
--------------

### SSH Command Action

**Location**: `.github/actions/ssh-command/action.yml`

Executes commands on a remote server via SSH.

#### Inputs:

*   `server-ip`: Server IP address
*   `server-ssh-port`: SSH port
*   `server-ssh-secret-key`: SSH private key
*   `server-ssh-user`: SSH username
*   `command`: Command to execute

#### Usage Example:

```yaml
- uses: ./composite-actions/.github/actions/ssh-command
  with:
    server-ip: '192.168.1.100'
    server-ssh-port: '22'
    server-ssh-secret-key: ${{ secrets.SSH_PRIVATE_KEY }}
    server-ssh-user: 'ubuntu'
    command: 'ls -la'
```

### Docker Compose Build and Restart Action

**Location**: `.github/actions/ssh-docker-compose/action.yml`

Pulls latest code and rebuilds/restarts Docker Compose services on a remote server.

#### Inputs:

*   `server-ip`: Server IP address
*   `server-ssh-port`: SSH port
*   `server-ssh-secret-key`: SSH private key
*   `server-ssh-user`: SSH username
*   `docker-compose-file`: Docker Compose file location

#### Usage Example:

```yaml
- uses: ./composite-actions/.github/actions/ssh-docker-compose
  with:
    server-ip: '192.168.1.100'
    server-ssh-port: '22'
    server-ssh-secret-key: ${{ secrets.SSH_PRIVATE_KEY }}
    server-ssh-user: 'ubuntu'
    docker-compose-file: './docker-compose.yml'
```


Notes
-----

1.  All actions require appropriate permissions and credentials to be set up in your GitHub repository secrets.
2.  Google Cloud operations require a valid service account with appropriate permissions.
3.  SSH operations require valid SSH credentials and proper network access to the target servers.
4.  Docker operations assume Docker is installed and properly configured in the environment.

Error Handling
--------------

Most scripts include error handling with:

*   `set -e`: Exits on first error
*   `set -u`: Errors on undefined variables
*   `set -x`: Prints commands before execution (useful for debugging)

Security Considerations
-----------------------

1.  Always use secrets for sensitive information
2.  Use specific versions for base images
3.  Implement proper access controls
4.  Regularly update dependencies
5.  Follow the principle of least privilege

For more information about individual scripts and their specific implementations, refer to the script files in the `helpers/` directory.

How to Implement Composite Actions
==================================

Prerequisites
-------------

*   GitHub repository with your application code
*   GitHub Personal Access Token (PAT) with `repo` access
*   The PAT stored as `GH_PAT` in your repository secrets

Implementation Steps
--------------------

### 1\. Create Workflow File

Create a new workflow file (e.g., `.github/workflows/deploy.yml`) in your repository.

### 2\. Configure Checkouts

Add the following checkout configuration that includes two checkouts:

*   Main repository checkout to `src` directory
*   Composite actions checkout to `composite-actions` directory
```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: Test
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          path: src
      - name: Checkout Akvo composite actions
        uses: actions/checkout@v4
        with:
          repository: akvo/composite-actions
          token: ${{ secrets.GH\_PAT }}
          path: composite-actions
          ref: 0.0.9
```
### 3\. Add Composite Actions

After the checkouts, you can use any of the available composite actions:

Example using Docker Build action
```yaml
- uses: ./composite-actions/.github/actions/docker-build
  with:
    app-name: 'your-app'
    service-name: 'your-service'
    dockerfile-location: './src/Dockerfile'
    cluster-name: 'your-cluster'
```
Available Actions
-----------------

You can use any of these actions after the checkouts:

*   `docker-build`
*   `docker-push`
*   `k8s-restart`
*   `k8s-rollout`
*   `node-operation`
*   `npm-operation`
*   `yarn-operation`
*   `ssh-command`
*   `ssh-docker-compose`
*   `rsync-to-server`

Important Notes
---------------

*   Ensure your PAT has necessary permissions
*   All paths in your workflow should reference the correct directory structure
*   Use appropriate environment variables and secrets

Impementation References
-----
1.  [Eswatini Droughtmap Hub](https://github.com/akvo/eswatini-droughtmap-hub/blob/main/.github/workflows/deploy.yml)
2.  [IDC Test](https://github.com/akvo/IDH-IDC/blob/main/.github/workflows/deploy.yml)
3.  [IDC Prod](https://github.com/akvo/IDH-IDC/blob/main/.github/workflows/release.yml)
4.  [Agriconnect (RagDoll)](https://github.com/akvo/rag-doll/blob/master/.github/workflows/deploy.yml)


