## Getting Started with Development Preview Content

Welcome to the hub for Red Hat Advanced Cluster Management Development preview content!  Many of our unique and upcoming features start as Development Preview content, available through the stolostron community for feedback and tight iteration as we discover and adapt to new use cases and usage patterns.

Below, you'll find a list of current dev-preview content complete with installation and usage instructions!  **Don't forget to give us feedback on our dev-preview content at acm-contact@redhat.com**. 

Features on Development Preview

- [Getting Started with Development Preview Content](#getting-started-with-development-preview-content)
- [Ansible Collection & Inventory Plugin](#ansible-collection--inventory-plugin)
  - [Installation](#installation)
  - [Usage](#usage)
- [Search-v2 - Odyssey](#search-v2---odyssey)
  - [Installation](#installation-1)
  - [Usage](#usage-1)
- [Configurable Collection in Search](#configurable-collection-in-search)
  - [Installation](#installation-2)
  - [Usage](#usage-2)
- [Dynamic Metric Collection (Custom Metrics Collection)](#dynamic-metric-collection-custom-metrics-collection)
  - [Installation](#installation-3)
  - [Usage](#usage-3)
- [Multicluster Global Hub](#multicluster-global-hub)
  - [Installation](#installation-4)
  - [Usage](#usage-4)
- [ACM Add-on for Multicluster Mesh](#acm-add-on-for-multicluster-mesh)
  - [Installation](#installation-5)
  - [Usage](#usage-5)
- [Hosted Control Planes with MCE/ACM](#hosted-control-planes-with-mceacm)
  - [Installation](#installation-6)
  - [Usage](#usage-6)
- [Finer-Grained Access Control to Observability Metrics](#finer-grained-access-control-to-observability-metrics)
  - [Installation](#installation-7)
  - [Usage](#usage-7)

## Ansible Collection & Inventory Plugin

This Ansible Collection allows your operations teams to stay in their comfort zone and leverage Ansible to orchestrate multicluster operations in kubernetes with Red Hat Advanced Cluster Management for Kubernetes and Multicluster Engine. This Ansible collection also includes an inventory plugin, which registers all ACM-managed cluters within the Ansible Inventory, allowing you to use your entire toolbelt of Ansible collections conventiently against your fleet of clusters.

**Repository**: [stolostron/ansible-collection.core](https://github.com/stolostron/ansible-collection.core)

### Installation

Installation instructions can be found in the [repo](https://github.com/stolostron/ansible-collection.core) and the collection can be found on [Ansible Galaxy](https://galaxy.ansible.com/stolostron/core).

### Usage

Usage instructions can be found in the [repo](https://github.com/stolostron/ansible-collection.core) and the collection can be found on [Ansible Galaxy](https://galaxy.ansible.com/stolostron/core).

## Search-v2 - Odyssey

Fueled by open source technology, the next evolution of our search capability allows fleet admins, SREs, and architects to quickly explore their multicluster landscape.  Search-v2 brings a re-architected backbone facilitating greater scale and resiliance within the service.  

**Repository**: [stolostron/search-v2-operator](https://github.com/stolostron/search-v2-operator)

### Installation

You can find the installation instructions for Search-v2 in the [operator repo's README](https://github.com/stolostron/search-v2-operator#installing-search-v2-operator-in-openshift-cluster)

### Usage

Search-v2 aims to improve the search experience while maintaining the current user experience.  Search-v2's usage should differ minimally from search v1 from the user-perspective, but scale and resiliance improvements can be found throughout the service backend!

## Configurable Collection in Search

You can now configure search parameters to increase response times and scale by reducing unncessary data collection, prevent the collection of secure or georesidency-limited information, and reduce the footprint of the search services on your hub cluster.  

**Repository**: [stolostron/search-collector](https://github.com/stolostron/search-collector)

### Installation

Deployment and configuration is overviewed in the [repository's README](https://github.com/stolostron/search-collector#dev-preview-search-configurable-collection).  

### Usage

The process for filtering resources is outlined [here](https://github.com/stolostron/search-collector#dev-preview-search-configurable-collection), in the repo's readme under "Dev Preview (Search Configurable Collection)".  

## Dynamic Metric Collection (Custom Metrics Collection)

Dynamic metrics collection refers to the ability to initiate metrics collection on managed clusters based on specific conditions. Collecting metrics consumes resources on your hub cluster. This is especially important when you considering metric collection across a large fleet of clusters. It makes sense to start collecting certain metrics only when they are likely going to be needed optimally using resources. When problems occur on a managed cluster, it may be necessary to collect metrics at a higher rate to help analyze the problems. Dynamic metrics collection enables both these use cases. Metrics collection stops automatically 15 minutes after the underlying condition no longer exists.

**Repository**: [stolostron/multicluster-observability-operator](https://github.com/stolostron/multicluster-observability-operator)

### Installation

No special installation is necessary to use this feature.

### Usage

Usage instructions and examples can be found in the [here](https://github.com/stolostron/multicluster-observability-operator/tree/main/dev-previews/dynamic-metrics-collection)

## Multicluster Global Hub

Hub of hubs enables users to manage more cluster than what an individual Hub can support.  The user can create or import OCP clusters to the Global Hub cluster as a leaf hub cluster.  The user can then deploy applications or policies in a single Global Hub which will then propogate to all matched managed clusters.  

**Repository**: [stolostron/multicluster-global-hub](https://github.com/stolostron/multicluster-global-hub)

### Installation

Installation instructions can be found in the [deployment section of the repo](https://github.com/stolostron/multicluster-global-hub/tree/release-2.5/deploy)!

### Usage

Usage instructions and examples can be found in the README, especially the [Getting Started Section](https://github.com/stolostron/multicluster-global-hub#getting-started).  

## ACM Add-on for Multicluster Mesh

This addon covers multiple use-cases:
* Service Mesh discovery: By discovering the service meshes spanning in managed clusters, the fleet administrator can have a global view of what service meshes exist and where these service meshes are located.
* Service Mesh deployment: The fleet administrator can deploy and configure service meshes to managed clusters from hub cluster, which unifies the configuration, operation of service meshes.
* Service Mesh federation: With mesh federation, multiple service meshes spanning in managed clusters can be combined, which enables secured mTLS , cross cluster traffic.

**Repository**: [stolostron/multicluster-mesh-addon](https://github.com/stolostron/multicluster-mesh-addon)

### Installation

Installation is covered in the [Getting Started section of the README](https://github.com/stolostron/multicluster-mesh-addon#getting-started).  

### Usage

Usage and use-case documentation can be found in the [How to use section of the README](https://github.com/stolostron/multicluster-mesh-addon#how-to-use).  


## Hosted Control Planes with MCE/ACM

Based on the [HyperShift project](https://hypershift-docs.netlify.app/), OpenShift with hosted control planes is a feature available as an add-on through the multicluster engine for kubernetes. Hosted control planes decouple the control-plane from the data-plane (workers), separates network domains, and provides a single pane of glass for easily operating your fleet of clusters. Now the control plane is just another workload, the same rich stack used to monitor, secure, and operate your applications can now be used for the control plane.

This feature is available as dev-preview for the following providers:

- [Azure](https://hypershift-docs.netlify.app/how-to/azure/create-azure-cluster/)
- [KubeVirt](https://hypershift-docs.netlify.app/how-to/kubevirt/create-kubevirt-cluster/)

**Repository**: [HyperShift Documentation](https://hypershift-docs.netlify.app/how-to/)

### Installation

Installation is covered in the [Provision Hypershift Clusters by MCE section](https://github.com/stolostron/hypershift-deployment-controller/blob/main/docs/provision_hypershift_clusters_by_mce.md).  

### Usage

Usage and use-case documentation can be found in the [Hosted Control Plane Clusters section of the doc](https://github.com/stolostron/hypershift-deployment-controller/blob/main/docs/content.md).  

## Finer-Grained Access Control to Observability Metrics

This feature provides the ability to control access to metrics collected from managed clusters at a namespace level granularity. The existing mechanism allows access control at a managed cluster level, this granularity is not sufficient when managed clusters are of large size and are shared by multiple teams or applications in the organization. In such cases, each team should gain access to only their team's metrics  and not all metrics collected from the managed-cluster.  Namespace level finer grained access control granularty enables configuring access to specific namespaces on the managed clusters thereby restricting a team member's metrics access to only those namespaces that belong to the team.

**Repository**: [stolostron/multicluster-observability-operator/dev-preview-fine-grain-rbac](https://github.com/stolostron/multicluster-observability-operator/tree/dev-preview-fine-grain-rbac)

### Installation

Follow the installation instructions in the above to install MCO operator, no additional special installation steps are necessary for this feature

### Usage

Usage instructions and examples can be found in the [here](https://github.com/stolostron/multicluster-observability-operator/tree/dev-preview-fine-grain-rbac/dev-previews/fine-grain-rbac)