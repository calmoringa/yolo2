
# Kubernetes YAML Files Explanation

This document explains the purpose and configuration of each Kubernetes YAML file used in the deployment of yolo application on Google Kubernetes Engine (GKE).

## 1. `deployment-backend.yml`

**Purpose:**
This file defines the Kubernetes Deployment for the backend service of your application. A Deployment ensures that a specified number of replicas of a containerized application are running at all times.

**Key Sections:**

- **Replicas:** Specifies the number of instances (pods) to run (e.g., 2 replicas).
- **Containers:** Defines the container to run, including the image (`unitybi/yolo:backend-v1.0.0`), ports, and environment variables.
- **Environment Variables:** The `MONGO_URL` environment variable is set to connect the backend to the MongoDB service.
- **Resources:** Specifies CPU and memory requests and limits to manage the resources for each pod.

## 2. `deployment-frontend.yml`

**Purpose:**
This file defines the Kubernetes Deployment for the frontend service of your application. Similar to the backend deployment, it ensures the frontend is always running and accessible.

**Key Sections:**

- **Replicas:** Specifies the number of frontend instances to run (e.g., 2 replicas).
- **Containers:** Defines the container, including the image (`unitybi/yolo:client-v1.0.0`), ports, and environment variables.
- **Resources:** Sets CPU and memory requests and limits for resource management.

## 3. `hpa-backend.yml`

**Purpose:**
This file defines the Horizontal Pod Autoscaler (HPA) for the backend service. The HPA automatically scales the number of pods in a deployment based on observed CPU utilization or other metrics.

**Key Sections:**

- **Target Deployment:** Links the autoscaler to the `backend-deployment`.
- **Metrics:** Configures the HPA to scale based on CPU utilization, specifying thresholds to trigger scaling up or down.

## 4. `persistent-volume.yml`

**Purpose:**
This file defines a PersistentVolume (PV) in Kubernetes, which provides storage resources to be used by the MongoDB StatefulSet. A PersistentVolumeClaim (PVC) is also included to request storage from the PV.

**Key Sections:**

- **PersistentVolume:** Describes the disk resource (`yolo-disk`) used for storage, including capacity and access modes.
- **PersistentVolumeClaim:** Requests storage for MongoDB, ensuring data persists across pod restarts.

## 5. `service-backend.yml`

**Purpose:**
This file defines a ClusterIP Service for the backend deployment. A ClusterIP service exposes the backend pods internally within the Kubernetes cluster, allowing other services (like the frontend) to communicate with it.

**Key Sections:**

- **Service Type:** ClusterIP is used for internal communication.
- **Ports:** Defines the port on which the backend service listens (e.g., port 8080).
- **Selectors:** Links the service to the appropriate backend pods using labels.

## 6. `service-db.yml`

**Purpose:**
This file defines a Headless Service for the MongoDB StatefulSet. A headless service does not have a ClusterIP and is used to manage the network identity of the MongoDB pods, allowing direct access to individual pod IPs.

**Key Sections:**

- **Service Type:** Headless, with no ClusterIP.
- **Ports:** Exposes MongoDB on port 27017.
- **Selectors:** Connects the service to the MongoDB StatefulSet pods.

## 7. `service-frontend.yml`

**Purpose:**
This file defines a LoadBalancer Service for the frontend deployment. A LoadBalancer service exposes the frontend pods to the internet, providing an external IP address for users to access the application.

**Key Sections:**

- **Service Type:** LoadBalancer to provide an external IP.
- **Ports:** Maps the frontend's container port to an external port (e.g., port 80).
- **Selectors:** Links the service to the appropriate frontend pods using labels.

## 8. `statefulset-db.yml`

**Purpose:**
This file defines a StatefulSet for MongoDB. A StatefulSet is used to manage stateful applications that require persistent storage, stable network identities, and ordered deployment, scaling, and updates.

**Key Sections:**

- **Replicas:** Specifies the number of MongoDB instances to run (e.g., 1 replica).
- **VolumeClaimTemplates:** Requests persistent storage for each MongoDB pod using a PVC.
- **Containers:** Defines the MongoDB container, including the image (`mongo:latest`), ports, and volume mounts.
- **ServiceName:** Specifies the headless service used for stable network identities.

---

These YAML files work together to deploy and manage a robust, scalable application on Kubernetes, with separate services for the frontend, backend, and database components, ensuring that each part of the application can communicate effectively and scale according to demand.

Here is a Markdown file that documents the entire process of deploying your application to Google Kubernetes Engine (GKE), including all the commands you used and the results.

---

![alt text](<screenshots/Screenshot 2024-08-18 at 17.12.19.png>) ![alt text](<screenshots/Screenshot 2024-08-18 at 17.12.57.png>) ![alt text](<screenshots/Screenshot 2024-08-18 at 17.13.26.png>) ![alt text](<screenshots/Screenshot 2024-08-18 at 17.13.42.png>) ![alt text](<screenshots/Screenshot 2024-08-18 at 17.13.57.png>) ![alt text](<screenshots/Screenshot 2024-08-18 at 17.15.29.png>)

# GKE Deployment Documentation

This section outlines the steps taken to deploy the `yolo-ecommerce` application on Google Kubernetes Engine (GKE) and describes the Kubernetes manifest files used.

## Project Configuration

### Set Up GCP Project

1. **Select GCP Project:**

    ```bash
    gcloud config set project moringa-432910
    ```

2. **Set Default Compute Region and Zone:**

    ```bash
    gcloud config set compute/region africa-south1
    gcloud config set compute/zone africa-south1-a
    ```

## Create GKE Cluster

1. **Create the GKE Cluster:**

    ```bash
    gcloud container clusters create yolo-cluster --zone africa-south1-a --num-nodes=3
    ```

2. **Get Credentials for the Cluster:**

    ```bash
    gcloud container clusters get-credentials yolo-cluster --zone africa-south1-a
    ```

## Kubernetes Manifests

### Persistent Volume

1. **Create the Persistent Disk:**

    ```bash
    gcloud compute disks create yolo-disk --size=10GB --zone=africa-south1-a
    ```

2. **Apply Persistent Volume Manifest:**

    ```bash
    kubectl apply -f manifests/persistent-volume.yml
    ```

### Deploy MongoDB

1. **Apply MongoDB StatefulSet and Service:**

    ```bash
    kubectl apply -f manifests/statefulset-db.yaml
    kubectl apply -f manifests/service-db.yaml
    ```

### Deploy Backend and Frontend

1. **Apply Backend Deployment:**

    ```bash
    kubectl apply -f manifests/deployment-backend.yml
    ```

2. **Apply Frontend Deployment:**

    ```bash
    kubectl apply -f manifests/deployment-frontend.yml
    ```

### Horizontal Pod Autoscaler

1. **Apply Horizontal Pod Autoscaler for Backend:**

    ```bash
    kubectl apply -f manifests/hpa-backend.yaml
    ```

### Service Verification

1. **Check Pods, Services, and Persistent Volumes:**

    ```bash
    kubectl get pods
    kubectl get svc
    kubectl get pv
    kubectl get pvc
    ```

## Troubleshooting

### Image Pull Issues

If you encounter `ImagePullBackOff` errors, ensure that your Docker images are correctly named and accessible in the Docker registry. Use the following commands to debug:

1. **Check Pod Logs:**

    ```bash
    kubectl logs <pod-name>
    ```

2. **Describe the Pod for More Details:**

    ```bash
    kubectl describe pod <pod-name>
    ```

### Application Connection to MongoDB

Ensure the backend and frontend deployments are configured with the correct MongoDB connection string by setting the `MONGO_URL` environment variable.

```yaml
env:
- name: MONGO_URL
  value: "mongodb://mongo-service:27017/yolo-db"
```

### Checking the Deployment Status

To verify the status of your deployments and services:

1. **Check Deployment Status:**

    ```bash
    kubectl get deployments
    kubectl get pods
    ```

2. **Check Service Status:**

    ```bash
    kubectl get svc
    ```

### Restarting and Redeploying

If any of your services are in a `CrashLoopBackOff` or `ImagePullBackOff` state, consider redeploying the services:

```bash
kubectl delete -f manifests/deployment-backend.yml
kubectl delete -f manifests/deployment-frontend.yml

kubectl apply -f manifests/deployment-backend.yml
kubectl apply -f manifests/deployment-frontend.yml
```

## Results

- **MongoDB Pod:** Successfully running.
- **Backend and Frontend Pods:** Resolved `ImagePullBackOff` errors by ensuring correct Docker images and registry access.
- **Services:** Frontend service exposed via LoadBalancer with an external IP.
- **External Ip:** <https://34.35.54.178>

## Final Verification

1. **Access the Frontend Application:**
    - Use the external IP provided by the frontend service's LoadBalancer.

    ```bash
    kubectl get svc frontend-service
    ```

2. **Monitor the Application:** Ensure that the frontend and backend are working together correctly, and the application connects to MongoDB.

---
