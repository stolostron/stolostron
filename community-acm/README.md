
# How to install the Advanced Cluster Management for Kubernetes community edition
## Console Quickstart
1. The minimum size for a Single node OpenShift in AWS is an m5.2xlarge (8 vCPU, 32GB RAM, 100GB DISK)
2. Connect to the OCP console
3. Navigate to `Operators` > `OperatorHub`
4. Search for `stolostron` and choose the `Stolostron` tile
5. Select the desired `Version` and press `Install`
6. Monitor the operator install `Status` from the OpenShift console `Operators` > `Installed Operators`, select the project `stolostron`, the console will show the `Stolostron` operator. Make sure the version displayed under the name `Stolostron` matches the expected version and that the `Status` shows `Succeeded`
6. Select the `Stolostron` operator and press the `Create MultiClusterHub` button
7. Keep the defaults and expand the `Advanced configuration` section, if you are using a 2xlarge single node OpenShift cluster, set the `Availability Configuration` to `Basic` to limit the size of the install
8. Press `Create`

### Monitoring the install
9. Navigate to the `Operators` > `Installed Operators` page, select the `stolostron-engine` project and look for the `Stolostron Engine` operator (may take a few minutes to appear) and watch the status, it will reach `Succeeeded` in about 5 minutes
10. After the `Stolostron Engine` operator `Suceeded`, the `MultiCluster Engine` resource will appear and reach `Status` `Phase: Available`. This can be seen on the `MultiCluster Engine` tab of the `Stolostron Engine` operator
11. Return to the `stolostron` project, and click into the `Stolostron` operator. On the `MultiClusterHubs` tab the resource will reach `Status` `Phase: Running` (10min total)
DONE!

## CLI Quickstart
1. The minimum size for a Single node OpenShift if availability basic is an AWS m5.2xlarge (8 vCPU, 32GB RAM, 100GB DISK)
2. Connect the `oc` cli to this cluster
3. Apply the operator subscription yaml
```
  oc apply -f ./operator/community-0.5.yaml
  
  # This creates a namespace(project), operator group and subscription in the stolostron namespace
```
4. Monitor the operator install `Status` with the following command:
   ```
   oc -n stolostron get csv
   ```
   The expected `Status` should reach `Succeeded`
5. Next create the `MultiClusterHub` resource:
   ```
   oc create -f ./multiclusterhub.yaml
   ```
6. Monitor the install status
   ```
   oc -n stolostron get multiclusterhub --watch
   ```
7. The install is complete when the `STATUS` reaches `Running`
8. During the install phase, the `Stolostron Engine` operator and the `multicluster-egnine` resource get created and installed
   ```
   oc -n stolostron-engine get csv
   ```
   The operator is ready when the `PHASE` is `Suceeded` (1-5min)
   Next the `multiclusterengine` resource is created automatically by the install, which can be monitored
   ```
   oc -n stolstron-engine get multiclusterengine
   ```
   The resource has completed installing when the `STATUS` reaches `Available`
9. One the monitoring command in step 6 shows `STATUS` `Running` the install is complete.
10. Visit the OpenShift console to start exploring
DONE!

## Uninstall
### Console
1. Navigate to `Operators` > `Installed Operator` and select the `stolostrong` project
2. Select the three virtical action dots for the `Stolostron` operator and choose `Uninstall Operator`
3. Select `Delete all operand instances for this operator` and press `Uninstall`
4. Delete takes about 10 minutes
DONE!

### CLI
1. Remove the `MultiClusterHub` resource from the `stolostron` project
   ```
   oc -n stolostron delete multiclusterhub multiclusterhub [--wait=false]
   ```
2. Delete takes about 10 minutes
DONE!

## Extras
### Hosted Control Planes
To leverage Hosted Control Planes in this build, you need to apply the following image override YAML
```
oc apply -f ./hcp-imageoverride.yaml
```