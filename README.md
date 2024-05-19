# Simple Backend API

This project is a simple backend API created as part of a challenge. The API includes a single route `/sayHello` which returns a JSON response with the message "Hello User". The API runs on port 80. The deployment is automated using GitHub Actions.

## Getting Started

### Prerequisites

- Node.js
- npm
- Git
- SSH key for accessing the virtual machine

### Installation

1. **Clone the repository:**

    ```sh
    git clone https://github.com/nitin1053/Backend_API.git
    cd simple-backend-api
    ```

2. **Install dependencies:**

    ```sh
    npm install
    ```

3. **Run the API:**

    ```sh
    sudo node index.js
    ```

    The server should now be running on port 80. You can test it by navigating to `http://localhost/sayHello` in your browser or using `curl`:

    ```sh
    curl http://localhost/sayHello
    ```

    You should see the following response:

    ```json
    {
        "message": "Hello User"
    }
    ```

## Deployment

The deployment is automated using GitHub Actions. The workflow is defined in the `.github/workflows/deploy.yml` file.

### GitHub Actions Workflow

The GitHub Actions workflow is triggered when code is pushed to the `master` branch. It performs the following steps:

1. **Checkout the code**
2. **Set up Node.js environment**
3. **Install dependencies**
4. **Deploy to the virtual machine**

### Setting Up Secrets

To securely deploy to the virtual machine, you need to add the SSH private key as a secret in your GitHub repository:

1. Go to your repository on GitHub.
2. Click on `Settings`.
3. Click on `Secrets` in the left sidebar.
4. Click on `New repository secret`.
5. Add a secret with the name `SSH_PRIVATE_KEY` and paste your private SSH key.

### Virtual Machine Details

- **Host:** 20.2.219.112
- **Username:** azureuser

### Workflow Configuration

Here is the content of `.github/workflows/deploy.yml`:

```yaml
name: Deploy API

on:
  push:
    branches:
      - master

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Set up Node.js
      uses: actions/setup-node@v2
      with:
        node-version: '14'

    - name: Install dependencies
      run: |
        npm install
    - name: Print debug info
      run: |
        echo "Debug Info"
        uname -a
        env
    - name: Copy files to VM
      uses: appleboy/scp-action@master
      with:
        host: ${{ secrets.VM_HOST }}
        username: ${{ secrets.VM_USERNAME }}
        key: ${{ secrets.VM_SSH_KEY }}
        source: "."
        target: "/home/azureuser/simple_backend_api"
      env:
        DEBUG: true

    - name: Run deployment script on VM
      uses: appleboy/ssh-action@master
      with:
        host: ${{ secrets.VM_HOST }}
        username: ${{ secrets.VM_USERNAME }}
        key: ${{ secrets.VM_SSH_KEY }}
        script: |
          cd /home/azureuser/simple_backend_api
          npm install
          sudo fuser -k 80/tcp || true
          nohup node index.js &
      env:
        DEBUG: true
