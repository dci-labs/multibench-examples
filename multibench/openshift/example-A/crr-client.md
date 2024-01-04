# Optimizing CRR client
## introduction
In the multi-bench setup, the first uperf scenario is built on a "Connection Request Response" (CRR) scenario. By default, an OS setting net.ipv4.tcp_tw_reuse is enabled, which limits the creation of connection on the CRR client side.

## The TCP Time Wait option
Time wait sockets are there to catch-up spurious retransmissions and/or lost last-ack.
e.g. if a tcp socket is almost closed, the server sends the final syn, the client replies with last-ack, but such packet is lost in between the server socket can't close completely, it will try re-transmission, but without TIME-WAIT, the client will not reply anymore and the server will keep the socket open for longer(until some timeout expires, considerably longer then TIME-WAIT).

## How to configure the multi-bench client

First, the worker node must be labeled for applying a KubeletConfig
```
oc label machineconfigpool worker custom-kubelet=sysctl
```
Then, creates a Kubelconfig that allow the change of this setting:
```yaml
apiVersion: machineconfiguration.openshift.io/v1
kind: KubeletConfig
metadata:
 name: custom-kubelet
spec:
 machineConfigPoolSelector:
   matchLabels:
      custom-kubelet: sysctl 
 kubeletConfig:
  allowedUnsafeSysctls:
   - "net.ipv4.tcp_tw_reuse"
```
The worker nodes will restart to apply the change.
When all your workers are ready, you can edit the multibench cmd by adding a security context file:
```bash
...
resources:client-15-20:$SCRIPT_DIR/resource-1req-daily.json,\
runtimeClassName:performance-blueprint-profile,\
PsecurityContext:client-1-20:$SCRIPT_DIR/security-context.json,\ <----
controller-ip:192.168.5.30,\
client:1-32,\
...
```
and the security-context.json file:
```json
"securityContext": {
      "sysctls": [
         {
            "name": "net.ipv4.tcp_tw_reuse",
            "value": "1"
         }
      ]
}
```
