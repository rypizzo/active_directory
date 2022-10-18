# Active Directory Setup

## Step 1 - setup images with Server 2022 (headless) and Windows 11 
## Step 2 - setup domain controller
1. Use `sconfig` to:
    - Change the hostname
    - Change IP address to static
    - Change DNS to own address
```shell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```


```
Get-NetIPAddress
```

# Joining the Workstation to the domain

```
Add-Computer -DomainName xyz.com -Credential xyz\Administrator -Force -Restart
```