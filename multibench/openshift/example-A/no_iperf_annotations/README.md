# No Iperf Configuration - with pods annotations


* Annotations applied to the pods - "cpu-quota.crio.io": "disable" and "irq-load-balancing.crio.io": "disable".
* Guarenteed pods with 2 CPUs and 500Mi of memory (request = limit) -> Need to have a number of CPU multiple of 2.
* Sepcified the runClassRuntime.
* Run only uperf (connections per sec)

This setup has been used to test nohz_full option, which is enabled like this in the PerformanceProfile:

```
spec:
  cpu:
    isolated: 1-19,21-39,41-59,61-79
    reserved: 0,40,20,60
  hugepages:
    pages:
    - count: 32
      node: 0
      size: 1G
    - count: 32
      node: 1
      size: 1G
  nodeSelector:
    node-role.kubernetes.io/worker: ""
  numa:
    topologyPolicy: single-numa-node
  realTimeKernel:
    enabled: false
  workloadHints:
    realTime: true   <--------------------------

```
