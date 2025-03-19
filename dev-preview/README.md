## Getting Started with Development Preview Content
<!-- This URL uses a tag so we can predict the value -->
Links: [Release-ACM-2.12/MCE-2.7](https://github.com/stolostron/stolostron/tree/2.12/dev-preview)

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
- [Global Hub Integration with Management Fabric](#global-hub-integration-with-management-fabric)
- [Improving Cluster Efficiency with Right Sizing](#improving-cluster-efficiency-with-right-sizing)
- [Image-Based Break/Fix (IBBF) for SNO Hardware Replacement](#image-based-breakfix-ibbf-for-sno-hardware-replacement)

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

## Global Hub Integration with Management Fabric

To aid the integration of the Red Hat Hybrid Cloud Management solutions, Management Fabric was created. A management solution like ACM creates, modifies or deletes a managed resource in its local inventory. Also, all these operations will be reported to the management fabric via the Asset Inventory APIs. Other Red Hat Hybrid Cloud Management solutions will follow the same path. Customers and ISV partners will be able to plug into Management Fabric to subscribe to these change events.

### Bring Management Fabric via the Global Hub Operator

The multicluster global hub can be able to install Management fabric in the on-premise environment.

#### Install the Global Hub Operator

Refer to [here](https://docs.redhat.com/en/documentation/red_hat_advanced_cluster_management_for_kubernetes/2.12/html/multicluster_global_hub/multicluster-global-hub#global-hub-install-connected) to install the multicluster global hub in your environment.

Though the document says that ACM hub is a pre-requisite for installing Global Hub, for the purposes of this dev preview, you can install it without creating an ACM hub.

#### Create the Global Hub Instance

Once the global hub operator is installed (with or without ACM hub), you need to add a new annotation `global-hub.open-cluster-management.io/with-inventory: ""` in the global hub instance to enable the inventory-api deployment in the global hub namespace.
You should be able to see the inventory-api deployment in the global hub namespace. The result looks like:
```
inventory-api-6c7567fcfb-n5qv9                  	                       1/1 	Running   0         	11h
inventory-api-f33567fcfb-p9zj5                  	                       1/1 	Running   0           11h
```

If you have installed the Global Hub Operator without installing the ACM hub on the Global Hub cluster, use [Verify the cluster information in Kafka topic](#verify-the-cluster-information-in-kafka-topic). However if you have installed ACM hub, you can skip to [Integrate Management Fabric](#integrate-management-fabric).

#### Verify the Cluster Information in Kafka Topic

You can use the curl command to talk with the inventory api which is exposed via OpenShift Route.
```
export inventory_api_route=$(oc -n multicluster-global-hub get route inventory-api -o jsonpath={.spec.host})
oc -n multicluster-global-hub get secret inventory-api-guest-certs -ojsonpath='{.data.tls\.key}' | base64 -d > /tmp/client.key
oc -n multicluster-global-hub get secret inventory-api-guest-certs -ojsonpath='{.data.tls\.crt}' | base64 -d > /tmp/client.crt
oc -n multicluster-global-hub get secret inventory-api-server-ca-certs -ojsonpath='{.data.ca\.crt}' | base64 -d > /tmp/ca.crt

curl --key /tmp/client.key --cert /tmp/client.crt  -H "Content-Type: application/json" --data "@data/k8s-cluster.json" --cacert /tmp/ca.crt https://$inventory_api_route:443/api/inventory/v1beta1/resources/k8s-clusters

cat data/k8s-cluster.json

{
 "k8s_cluster": {
   "metadata": {
     "resource_type": "k8s-cluster",
     "workspace": ""
   },
   "reporter_data": {
     "reporter_type": "ACM",
     "reporter_instance_id": "guest",
     "reporter_version": "0.1",
     "local_resource_id": "1",
     "api_href": "www.example.com",
     "console_href": "www.example.com"
   },
   "resource_data": {
     "external_cluster_id": "1234",
     "cluster_status": "READY",
     "kube_version": "1.31",
     "kube_vendor": "OPENSHIFT",
     "vendor_version": "4.16",
     "cloud_platform": "AWS_UPI",
     "nodes": [
       {
         "name": "www.example.com",
         "cpu": "7500m",
         "memory": "30973224Ki",
         "labels": [
           {
             "key": "has_monster_gpu",
             "value": "yes"
           }
         ]
       }
     ]
   }
 }
}
```
The cluster information should be sent to Kafka topic. We can use `kafka-console-consumer.sh` to check the results.
```
caPassword=`kubectl get secret kafka-cluster-ca-cert -o jsonpath='{.data.ca\.password}' | base64 -d`
kubectl get secret kafka-cluster-ca-cert -o jsonpath='{.data.ca\.p12}' | base64 -d > /tmp/ca.p12
kubectl get secret global-hub-kafka-user -o jsonpath='{.data.user\.p12}' | base64 -d > /tmp/user.p12
userPassword=`kubectl get secret  global-hub-kafka-user -o jsonpath='{.data.user\.password}' | base64 -d`
kubectl cp /tmp/user.p12 kafka-kafka-0:/tmp
kubectl cp /tmp/ca.p12 kafka-kafka-0:/tmp

cat << EOF > /tmp/client.properties
security.protocol=SSL
ssl.truststore.location=/tmp/ca.p12
ssl.truststore.password=${caPassword}
ssl.keystore.location=/tmp/user.p12
ssl.keystore.password=${userPassword}
EOF
kubectl cp /tmp/client.properties kafka-kafka-0:/tmp

# access pod to check topics
oc exec -it kafka-kafka-0 sh
bin/kafka-console-consumer.sh --bootstrap-server $kafka_bootstrap_server:443 --consumer.config=/tmp/client.properties --topic kessel-inventory --from-beginning
```
The result looks like this:
```
{"metadata":{"id":0,"last_reported":"2024-09-11T15:45:08.941075631Z","resource_type":"k8s-cluster","workspace":"","labels":null},"reporter_data":{"reporter_instance_id":"guest","reporter_type":"ACM","last_reported":"2024-09-11T15:45:08.941075631Z","local_resource_id":"1","reporter_version":"0.1","console_href":"www.example.com","api_href":"www.example.com"},"resource_data":{"external_cluster_id":"1234","cluster_status":"READY","kube_version":"1.31","kube_vendor":"OPENSHIFT","vendor_version":"4.16","cloud_platform":"AWS_UPI","nodes":[{"name":"www.example.com","cpu":"7500m","memory":"30973224Ki","labels":[{"key":"has_monster_gpu","value":"yes"}]}]}}
```
Congratulations! You have set up the environment correctly.

A Red Hat management tool like ACM would have automatically registered its cluster and policies etc using this API. In that case, you would directly see the events without having to make the API POST call.

#### Integrate Management Fabric

When you follow the [document](https://docs.redhat.com/en/documentation/red_hat_advanced_cluster_management_for_kubernetes/2.12/html/multicluster_global_hub/multicluster-global-hub#global-hub-importing-managed-hub-in-default-mode) to import a managed hub cluster into the global hub, you should be able to see the cluster cloudevents in Kafka `kessel-inventory` topic.
When you create a policy in the managed hub cluster, you can see the events including policy and relationships. The results look like this:
```
{
    "specversion": "1.0",
    "id": "e79857fa-8d00-11ef-ab88-0a580a8002c8",
    "source": "http://localhost:8081",
    "type": "redhat.inventory.resources.k8s-policy.created",
    "subject": "/resources/k8s-policy/open-cluster-management-global-set/test-local",
    "datacontenttype": "application/json",
    "time": "2024-10-18T03:27:29.676142591Z",
    "data": {
        "metadata": {
            "id": 1,
            "last_reported": "2024-10-18T03:27:29.676142591Z",
            "resource_type": "k8s-policy",
            "workspace": "",
            "labels": null
        },
        "reporter_data": {
            "reporter_instance_id": "mgdhub-1-client",
            "reporter_type": "ACM",
            "last_reported": "2024-10-18T03:27:29.677911526Z",
            "local_resource_id": "open-cluster-management-global-set/test-local",
            "reporter_version": "2.11.3",
            "console_href": "",
            "api_href": ""
        },
        "resource_data": {
            "disabled": false,
            "severity": "MEDIUM"
        }
    }
}

{
    "specversion": "1.0",
    "id": "ea695dc3-8d00-11ef-ab88-0a580a8002c8",
    "source": "http://localhost:8081",
    "type": "redhat.inventory.resources_relationship.k8s-policy_ispropagatedto_k8s-cluster.updated",
    "subject": "/resources_relationship/k8s-policy_ispropagatedto_k8s-cluster/open-cluster-management-global-set/test-local",
    "datacontenttype": "application/json",
    "time": "2024-10-18T03:27:34.406482298Z",
    "data": {
        "metadata": {
            "id": 0,
            "last_reported": "2024-10-18T03:27:34.406482298Z",
            "relationship_type": "k8s-policy_ispropagatedto_k8s-cluster"
        },
        "reporter_data": {
            "reporter_instance_id": "mgdhub-1-client",
            "reporter_type": "ACM",
            "last_reported": "2024-10-18T03:27:34.406482298Z",
            "subject_local_resource_id": "open-cluster-management-global-set/test-local",
            "object_local_resource_id": "managedcluster-1",
            "reporter_version": "2.11.3"
        },
        "relationship_data": {
            "status": "VIOLATIONS",
            "k8s_policy_id": 0,
            "k8s_cluster_id": 0
        }
    }
}
```
Congratulations! You have set up the environment correctly.

## Improving Cluster Efficiency with Right Sizing 

In the cloud-native world, efficiently managing resources is essential to optimize performance, control costs, and ensure operational efficiency. The **Right Sizing** feature in **ACM** has been enhanced to provide cluster administrators with valuable insights into resource usage and optimization.

Currently, there are two variants of Right Sizing available in dev-preview:

- **Namespace Level**: Focuses on resource insights at the namespace and cluster level.
- **Virtualization/VM Level**: Focuses on resource insights at the VM level.

To understand how this can help you optimize resources across multiple clusters, as well as learn about installation steps, detailed usage, and how to start using the feature, you can refer to the full documentation [here](https://github.com/stolostron/right-sizing/blob/main/README.md).

## Image-Based Break/Fix (IBBF) for SNO Hardware Replacement

The Image-Based Break/Fix (IBBF) feature streamlines Single Node OpenShift (SNO) hardware replacement, minimizing downtime while preserving the cluster’s original identity. It ensures that critical details, including cluster identifiers, cryptographic keys (such as kubeconfig), and authentication credentials, are retained. This allows the replacement node to seamlessly assume the identity of the failed hardware.

Designed for like-for-like hardware replacements and IBI-installed SNOs, IBBF introduces a GitOps-compatible, declarative API, enabling users to initiate hardware replacement with a single Git commit. Powered by the SiteConfig Operator and IBI Operator, this functionality allows clusters to be redeployed using the existing ClusterInstance CR. The SiteConfig Operator provides a flexible reinstallation service that integrates seamlessly with template-driven provisioning. Additionally, it includes a backup and restore mechanism for Secrets and ConfigMaps, ensuring the cluster retains its identity.

With IBBF, OpenShift users gain a resilient, automated, and GitOps-native solution for rapidly restoring SNO clusters after hardware failures.

Additionally, the SiteConfig Operator extends its reinstallation service to clusters provisioned via the Assisted Installer. However, unlike IBBF, where the cluster identity is preserved, Assisted Installer-based reinstallations generate a new cluster identity during the process.
