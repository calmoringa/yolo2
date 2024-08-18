
# Kubernetes Commands and Error Handling

This document provides a guide on how to use essential Kubernetes commands to manage and deploy your applications, along with scenarios for fixing common errors.

## Table of Contents

- [Checking Kubernetes Context](#checking-kubernetes-context)
  - [`kubectl config current-context`](#kubectl-config-current-context)
  - [`kubectl config get-contexts`](#kubectl-config-get-contexts)
  - [`kubectl config use-context <context-name>`](#kubectl-config-use-context-context-name)
  - [`kubectl config view`](#kubectl-config-view)
- [Working with Nodes](#working-with-nodes)
  - [`kubectl get nodes`](#kubectl-get-nodes)
- [Applying Kubernetes Manifests](#applying-kubernetes-manifests)
  - [`kubectl apply -f <filename>`](#kubectl-apply--f-filename)
  - [`kubectl apply -f <filename> --validate=false`](#kubectl-apply--f-filename---validatefalse)
- [Getting Minikube IP](#getting-minikube-ip)
  - [`minikube ip`](#minikube-ip)
- [Common Error Scenarios and Fixes](#common-error-scenarios-and-fixes)

## Checking Kubernetes Context

### `kubectl config current-context`

This command shows the current context that `kubectl` is using. The context determines which cluster and namespace `kubectl` interacts with.

```bash
kubectl config current-context
```

**Error Scenarios**:

- **Error**: `error: no context set`
  - **Fix**: Use `kubectl config use-context <context-name>` to set a valid context.

### `kubectl config get-contexts`

Lists all available contexts that `kubectl` can switch between. Each context represents a combination of cluster, namespace, and user settings.

```bash
kubectl config get-contexts
```

**Error Scenarios**:

- **Error**: `error: no contexts available`
  - **Fix**: Ensure that your `kubeconfig` file is correctly configured and points to valid clusters.

### `kubectl config use-context <context-name>`

Switches to the specified context.

```bash
kubectl config use-context <context-name>
```

Replace `<context-name>` with the name of the desired context.

**Error Scenarios**:

- **Error**: `error: context "<context-name>" does not exist`
  - **Fix**: Use `kubectl config get-contexts` to list available contexts and ensure the correct context name is used.

### `kubectl config view`

Displays the configuration information in the `kubeconfig` file. This is useful for troubleshooting context and cluster configurations.

```bash
kubectl config view
```

## Working with Nodes

### `kubectl get nodes`

Lists all the nodes in the current Kubernetes cluster. This command is useful for verifying that your cluster is up and running.

```bash
kubectl get nodes
```

**Error Scenarios**:

- **Error**: `The connection to the server <server-name> was refused - did you specify the right host or port?`
  - **Fix**: Ensure your cluster is running and that `kubectl` is configured to connect to the correct cluster.

## Applying Kubernetes Manifests

### `kubectl apply -f <filename>`

Applies the specified manifest file(s) to the cluster. This is the primary command for deploying resources like Pods, Services, Deployments, etc.

```bash
kubectl apply -f <filename>
```

Replace `<filename>` with the path to your YAML manifest file.

**Error Scenarios**:

- **Error**: `error: unable to recognize "<filename>": no matches for kind "<Kind>" in version "<Version>"`
  - **Fix**: Ensure that the manifest file uses the correct API version and resource kind.

### `kubectl apply -f <filename> --validate=false`

Applies the specified manifest file(s) to the cluster without validating them against the Kubernetes OpenAPI schema. This is useful for applying experimental or incomplete configurations.

```bash
kubectl apply -f <filename> --validate=false
```

**Use Case**:

- Use this option if you encounter validation errors that prevent you from applying a manifest file. However, be cautious as this may result in deploying resources that are not fully supported or configured correctly.

## Getting Minikube IP

### `minikube ip`

Returns the IP address of the Minikube cluster. This IP address can be used to access services exposed on a NodePort or LoadBalancer.

```bash
minikube ip
```

**Error Scenarios**:

- **Error**: `Error: cannot find an IP address for Minikube`
  - **Fix**: Ensure Minikube is running with `minikube start`.

## Common Error Scenarios and Fixes

### Scenario 1: `kubectl` Unable to Connect to Cluster

- **Symptom**: `The connection to the server <server-name> was refused - did you specify the right host or port?`
- **Fix**:
  - Verify that your cluster is running (`minikube status` or `aws eks describe-cluster`).
  - Ensure that `kubectl` is configured correctly with the proper context (`kubectl config use-context <context-name>`).

### Scenario 2: Validation Errors when Applying Manifests

- **Symptom**: `error: error validating "<filename>": error validating data: <details>`
- **Fix**:
  - Validate the manifest file syntax and structure.
  - Use the `--validate=false` flag with `kubectl apply` to bypass validation for experimental features.

### Scenario 3: Issues with Node Availability

- **Symptom**: `kubectl get nodes` returns no nodes or shows nodes in `NotReady` state.
- **Fix**:
  - Check the status of the underlying infrastructure (e.g., EC2 instances for EKS).
  - Ensure that the Kubernetes components (kubelet, kube-proxy) are running correctly on the nodes.

### Scenario 4: Service Not Accessible via LoadBalancer

- **Symptom**: Service exposed as LoadBalancer does not get an external IP or is not accessible.
- **Fix**:
  - Ensure the cloud provider's LoadBalancer service is correctly set up.
  - Check the service's status using `kubectl describe service <service-name>`.

---

This document should provide a solid foundation for using basic Kubernetes commands, deploying resources, and handling common errors you may encounter in your Kubernetes environment.
