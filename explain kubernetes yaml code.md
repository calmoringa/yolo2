Here is the YAML configuration with comments explaining each line of code and what it does:

```yaml
# This is the API version of the Kubernetes object. 
# "apps/v1" is used for deployments, which manage replica sets and Pods.
apiVersion: apps/v1

# The "kind" field specifies the type of Kubernetes object being created.
# In this case, it is a "Deployment", which manages a set of identical Pods.
kind: Deployment

# Metadata provides information about the deployment, including its name and labels.
metadata:
  # The name of the deployment. This name will be used to identify the deployment.
  name: frontend-deployment
  
  # Labels are key-value pairs attached to objects for identification and grouping.
  labels:
    # The "app" label is set to "frontend", which helps in identifying and selecting this deployment.
    app: frontend

# The specification ("spec") defines the desired state of the deployment.
spec:
  # Specifies the number of replicas (identical Pods) that should be running at all times.
  replicas: 2
  
  # The "selector" field defines how to find the Pods that belong to this deployment.
  selector:
    # "matchLabels" selects Pods that have the "app: frontend" label.
    matchLabels:
      app: frontend

  # The "template" defines the Pod specification, which will be used to create the Pods.
  template:
    # Metadata for the Pods created by this deployment, including labels.
    metadata:
      # The label "app: frontend" is applied to all Pods created by this deployment.
      labels:
        app: frontend
    
    # The "spec" field defines the containers that will run in the Pods.
    spec:
      # "containers" is a list of containers that will be created in each Pod.
      containers:
        # The name of the container.
        - name: frontend
        
          # The Docker image to use for the container. 
          # This image should be available in a container registry.
          image: unitybi/yolo:client-v1.0.0
          
          # The ports section specifies the port that the container listens on.
          ports:
            - containerPort: 3000
              # The container listens on port 3000. This is the port that will be exposed to other services in the cluster.

---

# frontend-service.yml

# API version for the Kubernetes Service object.
# "v1" is the stable API version for services in Kubernetes.
apiVersion: v1

# The "kind" field specifies the type of Kubernetes object.
# In this case, it is a "Service", which is an abstraction that defines a logical set of Pods and a policy to access them.
kind: Service

# Metadata provides information about the service, including its name and labels.
metadata:
  # The name of the service. This name will be used to identify the service.
  name: frontend-service

# The specification ("spec") defines the desired state of the service.
spec:
  # "selector" is used to identify the Pods that the service should route traffic to.
  selector:
    # The service will route traffic to Pods that have the "app: frontend" label.
    app: frontend
  
  # "ports" defines the list of ports that the service will expose.
  ports:
    - protocol: TCP
      # The port that the service will expose to the outside world.
      port: 80
      
      # The port on the Pods that the service will route traffic to.
      targetPort: 3000

  # "type: LoadBalancer" exposes the service externally using a cloud provider's load balancer.
  type: LoadBalancer
```

### Summary of Key Concepts

- **Deployment**: Manages a set of identical Pods, ensuring that the specified number of replicas are running.
- **Pod**: A group of one or more containers that share storage, network, and a specification for how to run the containers.
- **Service**: An abstraction that defines a logical set of Pods and a policy by which to access them, often used to expose applications running on Pods to the outside world or within the cluster.

This setup defines a Kubernetes Deployment that runs two replicas of a frontend application and exposes the application to external traffic via a LoadBalancer Service.
