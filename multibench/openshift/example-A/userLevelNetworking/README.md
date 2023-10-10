# userLevelNetworking option

As this option is too restrictive, enabling with this option in the PerformanceProfile:
```
  net:
    userLevelNetworking: false
```
But it set the number of interruptVector by NIC equals to the number of reserved CPU.
To change manually this setting, it must be change via the creation of a tuned, see the tuned.yml file.
