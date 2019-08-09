# PowerV
Hyper-V Automation Scripts

### vm_creator.ps1
Automates creating a VM.

You interactively specify:
* VM name
* ISO file
* the switch
* the amount of RAM
* disk size
* secure boot (enabled/disabled)
* Hyper V VM generation (1 or 2)

However you have to set the location of the ISO files and the VM storage inside the config.xml file.

Example:

```powershell
PS C:\Users\Administrator\Documents\vms> .\vm_creator.ps1
ISOs available:
1) AlienVault_OSSIM_64bits.iso
2) IE11.Win7.VMWare.zip
3) pfSense-CE-2.4.4-RELEASE-p1-amd64.iso
4) ubuntu-18.04.2-desktop-amd64.iso
5) ubuntu-18.04.2-live-server-amd64.iso
6) Windows_Server_2016_Datacenter_EVAL_en-us_14393_refresh.iso
Select an ISO file (enter number): 6
Switches available(if you dont see any, configure them on hyper-v first):
1) VMSwitch (Name = 'ExternalSwitch') [Id = 'da385cf6-ea5b-4c79-8b2a-7a51817ccd02']
2) VMSwitch (Name = 'InternalSwitch') [Id = '090dfb9d-949a-49e2-984d-d9beaa3853c9']
Select a switch (enter number): 1
Enter VM name: win16
Enter RAM capacity (in GB, ex: 2 = 2 GB): 4
Enter disk capacity (in GB, ex: 40 = 40GB): 50
Secure Boot (on/off): on
Enter Hyper-V vm generation (1 or 2): 2
configuration summary:
>VM Name: win16
>ISO: Windows_Server_2016_Datacenter_EVAL_en-us_14393_refresh.iso
>Switch: ExternalSwitch
>Disk Capacity: 53687091200 Bytes
>Ram Capacity: 4294967296 Bytes
>VM Generation: 2
>Secure Boot: on
Accept Configuration (y/n): y
Creating VM..

Adding DVD drive to VM...
Adding ISO file to DVD drive...
Configuring VM to boot from DVD drive...
Starting VM...
One sec...
Done!
Name  State   CPUUsage(%) MemoryAssigned(M) Uptime   Status             Version
----  -----   ----------- ----------------- ------   ------             -------
win16 Off     0           0                 00:00:00 Operating normally 8.0
win16 Running 24          4096              00:00:03 Operating normally 8.0

```
