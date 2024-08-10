
### Key Files and Directories

#### Vagrantfile

- **Purpose**: Defines the virtual machine configuration for Vagrant.
- **Key Functions**:
  - Specifies the base box (`geerlingguy/ubuntu2004`) for the VM.
  - Configures networking options.
  - Sets up synced folders for sharing files between host and VM.
  - Includes a shell provisioner to install Docker and Docker Compose.

#### playbook.yml

- **Purpose**: Ansible playbook that orchestrates the deployment process.
- **Key Functions**:
  - Lists the roles to be executed on the VM in sequence.
  - Handles the automation of cloning the repository, setting up MongoDB, and deploying frontend and backend services.

#### roles/

The `roles/` directory contains individual roles for managing different aspects of the deployment process. Each role has a `tasks/main.yml` file that defines the steps to be executed.

##### clone-repository/

- **Purpose**: Clones the application code from GitHub to the VM.
- **Key Files**:
  - **tasks/main.yml**: Uses the Ansible `git` module to clone the repository. This ensures that the latest version of the code is always available for deployment.

##### setup-mongodb/

- **Purpose**: Sets up MongoDB in a Docker container.
- **Key Files**:
  - **tasks/main.yml**:
    - Creates a Docker volume for data persistence.
    - Creates a Docker network for service communication.
    - Starts the MongoDB container and ensures it is running.

##### backend-deployment/

- **Purpose**: Builds and deploys the backend service.
- **Key Files**:
  - **tasks/main.yml**:
    - Copies the backend Docker Compose file to the VM.
    - Runs Docker Compose to build and start the backend service.
    - Waits for the backend to be ready before proceeding.
  - **files/backend-docker-compose.yml**: Defines the Docker Compose configuration for the backend service, specifying the build context, ports, and service dependencies.

##### frontend-deployment/

- **Purpose**: Builds and deploys the frontend service.
- **Key Files**:
  - **tasks/main.yml**:
    - Copies the frontend Docker Compose file to the VM.
    - Runs Docker Compose to build and start the frontend service.
    - Waits for the backend to be ready before starting the frontend.
  - **files/frontend-docker-compose.yml**: Defines the Docker Compose configuration for the frontend service, specifying the build context, ports, and service dependencies.

### How to Use

1. **Install Vagrant and VirtualBox**: Ensure Vagrant and VirtualBox are installed on your machine.

2. **Clone the Project**: Clone this project to your local machine.

3. **Start Vagrant**: Run `vagrant up` in the project directory. This will start the VM and provision it using Ansible.

4. **Access the Application**: Once provisioning is complete, access the application via the specified ports:
   - Frontend: `http://192.168.100.99:3000`
   - Backend: `http://192.168.100.99:5000`

### Proof of work

### Conclusion

This setup provides a robust environment for developing and testing your application locally. By using Vagrant, Ansible, and Docker, we ensure consistency and reproducibility across different development environments. Each component is isolated and managed independently, allowing for easy updates and maintenance.