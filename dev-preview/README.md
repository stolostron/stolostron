## Getting Started with Development Preview Content

Welcome to the hub for Red Hat Advanced Cluster Management Developement preview content!  Many of our unique and upcoming features start as Development Preview content, available through the stolostron community for feedback and tight iteration as we discover and adapt to new use cases and usage patterns.   

Below, you'll find a list of current dev-preview content complete with installation and usage instructions!  **Don't forget to give us feedback on our dev-preview content at acm-contact@redhat.com**. 
Features on Development Preview
- [Ansible Collection & Inventory Plugin](#Ansible-Collection-Inventory-Plugin)
- [Search v2 - Odyssey](#Search-v2-Odyssey)
- [Configurable Collection in Search](#Configurable-Collection-in-Search)
- [Dynamic Metric Collection (Custom Metrics Collectoin)](#Dynamic-Metric-Collection-Custom Metrics Collectoin)
- [Hub of Hubs](#Hub-of-Hubs)
- [ACM Add-on for Multicluster Mesh](#ACM-Add-on-for-Multicluster-Mesh)
## Ansible Collection & Inventory Plugin

This Ansible Collection allows your operations teams to stay in their comfort zone and leverage Ansible to orchestrate multicluster operations in kubernetes with Red Hat Advanced Cluster Management for Kubernetes and Multicluster Engine. This Ansible collection also includes an inventory plugin, which registers all ACM-managed cluters within the Ansible Inventory, allowing you to use your entire toolbelt of Ansible collections conventiently agiainst your fleet of clusters.  

**Repository**: [stolostron/ocmplus.cm](https://github.com/stolostron/ocmplus.cm)

### Installation

Installation instructions can be found in the [repo](https://github.com/stolostron/ocmplus.cm) and the collection will eventually target [Ansible Galaxy](https://galaxy.ansible.com/).  

### Usage

Usage instructions can be found in the [repo](https://github.com/stolostron/ocmplus.cm) and will eventually be found in [Ansible Galaxy](https://galaxy.ansible.com/).  

## Search v2 - Odyssey

Fueled by open source technology, the next evolution of our search capability allows fleet admins, SREs, and architects to quickly explore their multicluster landscape.  Search v2 brings a re-architected backbone facilitating greater scale and resiliance within the service.  

**Repository**: [stolostron/search-v2-operator](https://github.com/stolostron/search-v2-operator)

### Installation

You can find the installation instructions for Search-v2 in the [operator repo's README](https://github.com/stolostron/search-v2-operator#installing-search-v2-operator-in-openshift-cluster)

### Usage

Search-v2 aims to improve the search experience while maintaining the current user experience.  Search v2's usage should differ minimally from search v1 from the user-perspective, but scale and resiliance improvements can be found throughout the service backend!

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

Installation instructions can be found in the [deployment section of the repo](https://github.com/stolostron/hub-of-hubs/tree/main/deploy)!

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
