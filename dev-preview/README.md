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
- [Dynamic Metric Collection (Custom Metrics Collectoin)](#dynamic-metric-collection-custom-metrics-collectoin)
- [Hub of Hubs](#hub-of-hubs)
  - [Installation](#installation-3)
  - [Usage](#usage-3)
- [ACM Add-on for Multicluster Mesh](#acm-add-on-for-multicluster-mesh)
  - [Installation](#installation-4)
  - [Usage](#usage-4)
- [Hosted Control Planes with MCE/ACM](#hosted-control-planes-with-mceacm)
  - [Installation](#installation-5)
  - [Usage](#usage-5)

## Ansible Collection & Inventory Plugin

This Ansible Collection allows your operations teams to stay in their comfort zone and leverage Ansible to orchestrate multicluster operations in kubernetes with Red Hat Advanced Cluster Management for Kubernetes and Multicluster Engine. This Ansible collection also includes an inventory plugin, which registers all ACM-managed cluters within the Ansible Inventory, allowing you to use your entire toolbelt of Ansible collections conventiently agiainst your fleet of clusters.  

**Repository**: [stolostron/ocmplus.cm](https://github.com/stolostron/ocmplus.cm)

### Installation

Installation instructions can be found in the [repo](https://github.com/stolostron/ocmplus.cm) and the collection will eventually target [Ansible Galaxy](https://galaxy.ansible.com/).  

### Usage

Usage instructions can be found in the [repo](https://github.com/stolostron/ocmplus.cm) and will eventually be found in [Ansible Galaxy](https://galaxy.ansible.com/).  

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

## Dynamic Metric Collection (Custom Metrics Collectoin)

Details Coming Soon!

## Hub of Hubs

Hub of hubs enables users to manage more cluster than what an individual Hub can support.  The user can create or import OCP clusters to the hub-of-hubs cluster as a leaf hub cluster.  The user can then deploy applications or policies in a single hub-of-hubs which will then propogate to all matched managed clusters.  

**Repository**: [stolostron/hub-of-hubs](https://github.com/stolostron/hub-of-hubs)

### Installation

Installation instructions can be found in the [deployment section of the repo](https://github.com/stolostron/hub-of-hubs/tree/release-2.5/deploy)!

### Usage

Usage instructions and examples can be found in the README, especially the [Getting Started Section](https://github.com/stolostron/hub-of-hubs#getting-started).  

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

- Azure
- Baremetal (with Assisted-agent flow)
- KubeVirt

**Repository**: [stolostron/hypershift-deployment-controller](https://github.com/stolostron/hypershift-deployment-controller)

### Installation

Installation is covered in the [Provision Hypershift Clusters by MCE section](https://github.com/stolostron/hypershift-deployment-controller/blob/main/docs/provision_hypershift_clusters_by_mce.md).  

### Usage

Usage and use-case documentation can be found in the [Hosted Control Plane Clusters section of the doc](https://github.com/stolostron/hypershift-deployment-controller/blob/main/docs/content.md).  
