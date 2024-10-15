## Getting Started with Development Preview Content
<!-- This URL uses a tag so we can predict the value -->
Links: [Release-ACM-2.11/MCE-2.6](https://github.com/stolostron/stolostron/tree/2.11/dev-preview)

Welcome to the hub for Red Hat Advanced Cluster Management Development preview content!  Many of our unique and upcoming features start as Development Preview content, available through the stolostron community for feedback and tight iteration as we discover and adapt to new use cases and usage patterns.

Below, you'll find a list of current dev-preview content complete with installation and usage instructions!  **Don't forget to give us feedback on our dev-preview content at acm-contact@redhat.com**.

Features on Development Preview

- [Getting Started with Development Preview Content](#getting-started-with-development-preview-content)
- [Ansible Collection \& Inventory Plugin](#ansible-collection--inventory-plugin)
  - [Installation](#installation)
  - [Usage](#usage)
- [Dynamic Metric Collection (Custom Metrics Collection)](#dynamic-metric-collection-custom-metrics-collection)
  - [Installation](#installation-1)
  - [Usage](#usage-1)
- [Observability Instance Sizes](#observability-instance-sizes)
  - [Installation](#installation-2)
  - [Usage](#usage-2)
- [Edge Management](#edge-management)
  - [Installation](#installation-3)
  - [Usage](#usage-3)
- [Global Hub Integration with Red Hat Advanced Cluster Security](#global-hub-integration-with-red-hat-advanced-cluster-security)

## Ansible Collection & Inventory Plugin

This Ansible Collection allows your operations teams to stay in their comfort zone and leverage Ansible to orchestrate multicluster operations in kubernetes with Red Hat Advanced Cluster Management for Kubernetes and Multicluster Engine. This Ansible collection also includes an inventory plugin, which registers all ACM-managed cluters within the Ansible Inventory, allowing you to use your entire toolbelt of Ansible collections conventiently against your fleet of clusters.

**Repository**: [stolostron/ansible-collection.core](https://github.com/stolostron/ansible-collection.core)

### Installation

Installation instructions can be found in the [repo](https://github.com/stolostron/ansible-collection.core) and the collection can be found on [Ansible Galaxy](https://galaxy.ansible.com/stolostron/core).

### Usage

Usage instructions can be found in the [repo](https://github.com/stolostron/ansible-collection.core) and the collection can be found on [Ansible Galaxy](https://galaxy.ansible.com/stolostron/core).

## Dynamic Metric Collection (Custom Metrics Collection) <!-- [ACM 2.8+] -->

Dynamic metrics collection refers to the ability to initiate metrics collection on managed clusters based on specific conditions. Collecting metrics consumes resources on your hub cluster. This is especially important when you considering metric collection across a large fleet of clusters. It makes sense to start collecting certain metrics only when they are likely going to be needed optimally using resources. When problems occur on a managed cluster, it may be necessary to collect metrics at a higher rate to help analyze the problems. Dynamic metrics collection enables both these use cases. Metrics collection stops automatically 15 minutes after the underlying condition no longer exists.

**Repository**: [stolostron/multicluster-observability-operator](https://github.com/stolostron/multicluster-observability-operator)

### Installation

No special installation is necessary to use this feature.

### Usage

Usage instructions and examples can be found in the [here](https://github.com/stolostron/multicluster-observability-operator/tree/main/dev-previews/dynamic-metrics-collection)

## Observability Instance Sizes

This feature provides the ability to control the scale of your ACM Observability instance. The existing mechanism to scale up Observability resources in the hub is to use `AdvancedConfig` in MultiClusterObservability CR. But this requires the user to be familiar with the intricacies of the components within Observability (Thanos. AlertManager, Observatorium API, etc.).

With Instance Sizes, users can now configure a set of resource requests across all their Observability components, sized proportionally, using a single field in their MCO CR, `InstanceSize`.

The sizes currently supported are: minimal, default, small, medium, large, xLarge, 2xLarge and 4xLarge, which represents a linear scale of usage for ACM MCO.
By default `InstanceSize` is set to `default`. This feature is entirely opt-in, and your existing `AdvancedConfig` will always override it.

The sizes themselves proportionally size MCO components according to a practical scale of usage. Our estimates indicate a measure like below (here total CPU/Memory are approximate request values for Hub Observability components),

| InstanceSize  | Active Timeseries Supported | Total CPU Request | Total Memory Request (GiB) |
|---------------|-----------------------------|-------------------|----------------------------|
| Default       | < 200k                      |                  3|                          12|
| Minimal       | < 1 million                 |                 16|                          25|
| Small         | 1 million                   |                 32|                          72|
| Medium        | 5 million                   |                 55|                         137|
| Large         | 10 million                  |                103|                         293|
| Xlarge        | 20 million                  |                163|                         590|
| 2xlarge       | 50 million                  |                222|                        1019|
| 4xlarge       | 100 million                 |                337|                        2158|


For details on how to size your cluster before enabling an InstanceSize, refer to this [spreadsheet](https://docs.google.com/spreadsheets/d/1ye8wDROJW2_VpR4imPtwXANJuBSWHCWKegoUzz-bWdU/edit?gid=0#gid=0).

### Installation

Follow the installation instructions in the above to install MCO operator, and ensure you have enough resources to support the particular size size.

### Usage

Simply set `InstanceSize` field on MCO CR to a value that would suit your monitoring needs.

## Edge Management

Edge Management aims to provide simple, scalable, and secure management of edge servers or devices running image-mode RHEL / RHDE and applications on Podman or MicroShift. Users declare the operating system version, host configuration, and set of applications they want to run similarly to how they would on edge clusters with OpenShift. Edge Management further debuts fleet management, enabling users to specify device templates that Edge Management automatically rolls out to groups of devices and reports progress and health status on.

**Repository**: [flightctl/flightctl](https://github.com/flightctl/flightctl)

### Installation

Installation instructions can be found in the [repo](https://github.com/flightctl/flightctl/blob/v0.2.2/docs/user/getting-started.md#flightctl-in-acm).

### Usage

Instructions for managing fleets can be found [here](https://github.com/flightctl/flightctl/blob/main/docs/user/managing-fleets.md) while for managing devices are available [here](https://github.com/flightctl/flightctl/blob/main/docs/user/managing-devices.md). One of the benefits of using Edge Management together with ACM is the ability to enroll devices running Red Hat Device Edge seamlessly.

## Global Hub Integration with Red Hat Advanced Cluster Security

This feature adds to the Global Hub the capability to aggregate data from the
Red Hat Advanced Cluster Security instances that run in the managed hubs. The
aggregated data is available in a new _Security Violations_ dashboard. For more
details and configuration instructions see the Global Hub documentation
[here](https://github.com/stolostron/multicluster-global-hub/blob/main/doc/dev-preview.md#enable-rhacs-integration).

## OpenShift Cluster API Operator

The OpenShift Cluster API Operator is a Kubernetes Operator built to enable cluster administrators to manage the lifecycle of Cluster API providers. Specifically, it supports lifecycle management of ROSA Hosted Control Plane (HCP) clusters within a ACM/MCE cluster using a declarative approach. Its goal is to enhance the user experience in deploying and managing ROSA HCP (and ARO HCP in future), simplifying daily tasks (upgrades & node management) and streamlining automation workflows through GitOps.

OpenShift Cluster API Operator helm chart uses the redhat-registry container images to deploy the cluster-api-operator, cluster-api and cluster-api-aws-providers. 

##### Note:

A constrain for the OpenShift Cluster API Operator helm chart devPreview release; It is not supported to use the MCE (HyperShift) operator to provision a host control plane cluster while using the OpenShift cluster API operator helm chart.

### Installation
[Cert-Manager](https://docs.openshift.com/container-platform/4.17/security/cert_manager_operator/index.html) operator is a pre-request to install the OpenShift cluster api operator. To install the Cert-Manager opertator follow the the RedHat documentation instructions [here](https://docs.openshift.com/container-platform/4.17/security/cert_manager_operator/cert-manager-operator-install.html) OR apply the below Subscription, Namespace and OperatorGroup CRs (custom resource).
```
apiVersion: v1
kind: Namespace
metadata:
  name: cert-manager-operator
---
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: openshift-cert-manager-operator
  namespace: cert-manager-operator
spec:
  targetNamespaces:
  - "cert-manager-operator"
---
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: openshift-cert-manager-operator
  namespace: cert-manager-operator
spec:
  channel: stable-v1
  name: openshift-cert-manager-operator
  source: redhat-operators
  sourceNamespace: openshift-marketplace
  installPlanApproval: Automatic
  startingCSV: cert-manager-operator.v1.14.0
```

##### Note:
Using the Cert-Manager helm chart instead of the RedHat Cert-Manager operator for non OpenShift clusters. Follow the instruction [here](https://cert-manager.io/v1.6-docs/installation/helm/) to use the Cert-Manager helm chart.

Add CAPI Operator helm repository:
```
$ helm repo add capi-operator https://raw.githubusercontent.com/openshift/cluster-api-operator/refs/heads/main/openshift
$ helm repo update
```

Follow the instructions below to create the AWS credentials environment variable:
```
$ export AWS_REGION=us-east-1 
$ export AWS_ACCESS_KEY_ID=<your-access-key>
$ export AWS_SECRET_ACCESS_KEY=<your-secret-access-key>
$ export AWS_SESSION_TOKEN=<session-token> # If you are using Multi-Factor Auth.
$ export AWS_B64ENCODED_CREDENTIALS=$(clusterawsadm bootstrap credentials encode-as-profile|base64 -w0)
$ echo $AWS_B64ENCODED_CREDENTIALS
```
Install the OpenShift Cluster-api-operator
```
$ helm upgrade --install capi-operator capi-operator/cluster-api-operator --create-namespace -n capi-operator-system --set awsEncodedCredentials=$AWS_B64ENCODED_CREDENTIALS
```
##### Note:
To set the RedHat OpenShift credentials at the cluster-api-aws-provider visit https://console.redhat.com/openshift/token to retrieve your API authentication token. Then run the helm install command with the redhat credentials token defined as below.
```
$ helm upgrade --install capi-operator capi-operator/cluster-api-operator --create-namespace -n capi-operator-system --set awsEncodedCredentials=$AWS_B64ENCODED_CREDENTIALS --set ocmToken=<set-redhat-api-credentials-token>
```
### Usage
The OpenShift Cluster API Operator deploys the main components (CAPI & CAPA deployments) that allows provisioning ROSA HCP clusters. Follow the [ROSA documentation](https://cluster-api-aws.sigs.k8s.io/topics/rosa/creating-a-cluster) to provision a ROSA-HCP cluster. For troubleshooting the OpenShift Cluster API Operator follow the docunmentation [here](https://github.com/openshift/cluster-api-operator/blob/main/openshift/README.md)


# Graduated features

### Hosted Control Planes with MCE (MCE 2.5)

  * Usage and use-case documentation can be found in the [Hosted Control Plane Clusters section of the doc](https://docs.redhat.com/en/documentation/red_hat_advanced_cluster_management_for_kubernetes/2.11/html/multicluster_global_hub/index).

### Multicluster Global Hub (ACM 2.9)

  * Usage instructions and examples can be found in the [Getting Started Section](https://docs.redhat.com/en/documentation/red_hat_advanced_cluster_management_for_kubernetes/2.11/html/clusters/cluster_mce_overview#hosted-control-planes-intro).

### Finer-Grained Access Control to Observability Metrics (ACM 2.11)

  * Usage instructions and examples can be found [here](https://docs.redhat.com/en/documentation/red_hat_advanced_cluster_management_for_kubernetes/2.11/html-single/observability/index#configure-fine-grain-rbac)

### Configurable Collection in Search (ACM 2.7)

  * The process for filtering resources is outlined [here](https://docs.redhat.com/en/documentation/red_hat_advanced_cluster_management_for_kubernetes/2.11/html-single/observability/index#creating-search-configurable-collection).

### Search-v2 - Odyssey

  * Search-v2 brings a re-architected backbone facilitating greater scale and resiliance within the service.
