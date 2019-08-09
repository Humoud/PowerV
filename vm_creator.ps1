# Load config file
[xml]$configFile= get-content config.xml

# ISO Selection / installation media
Write-Host "ISOs available:" -ForegroundColor red -BackgroundColor White
$isos = Get-ChildItem -Path $configFile.configuration.isoPath
$counter = 1
foreach($iso in $isos){
    Write-Host "$counter) $iso"
    $counter++
}
$iso_number = $(Write-Host 'Select an ISO file (enter number): ' -ForegroundColor Red  -BackgroundColor White -NoNewline; Read-Host)
$ISOFile = $isos[$iso_number-1]
###########################################################
# Switch Selection
Write-Host "Switches available(if you dont see any, configure them on hyper-v first):" -ForegroundColor Red -BackgroundColor White
$switches = Get-VMSwitch  *
$counter = 1
foreach($sw in $switches){
    Write-Host "$counter) $sw"
    $counter++
}
$sw_number = $(Write-Host 'Select a switch (enter number): ' -ForegroundColor Red -BackgroundColor White -NoNewline; Read-Host)
[string]$switch = $switches[$sw_number-1]
$switch = $switch.split("'")[1]
###############################################################
# Vm Name
$VMName = $(Write-Host 'Enter VM name: ' -ForegroundColor red -BackgroundColor White -NoNewline; Read-Host)
# RAM capacity in GB
[int64]$ram = $(Write-Host 'Enter RAM capacity (in GB, ex: 2 = 2 GB): ' -ForegroundColor Red -BackgroundColor White -NoNewline; 1GB*(Read-Host))
# Disk capacity in GB
[int64]$disk = $(Write-Host 'Enter disk capacity (in GB, ex: 40 = 40GB): ' -ForegroundColor Red -BackgroundColor White -NoNewline; 1GB*(Read-Host))
# Secure boot
$secureBoot = $(Write-Host 'Secure Boot (on/off): ' -ForegroundColor Red -BackgroundColor White -NoNewline; Read-Host)
# Hyper-v vm generation (1 or 2)
$VMGen = $(Write-Host 'Enter Hyper-V vm generation (1 or 2): ' -ForegroundColor Red -BackgroundColor White -NoNewline; Read-Host)

# confirm config:
Write-Host "configuration summary:" -ForegroundColor Green
Write-Host ">VM Name: $VMName" -ForegroundColor Green
Write-Host ">ISO: $ISOFile" -ForegroundColor Green
Write-Host ">Switch: $switch" -ForegroundColor Green
Write-Host ">Disk Capacity: $disk Bytes" -ForegroundColor Green
Write-Host ">Ram Capacity: $ram Bytes" -ForegroundColor Green
Write-Host ">VM Generation: $VMGen" -ForegroundColor Green
Write-Host ">Secure Boot: $secureBoot" -ForegroundColor Green
$accept = Read-Host -Prompt 'Accept Configuration (y/n)'

if($accept.ToLower() -eq "y"){
    Write-Host "Creating VM.."

    $VHDPath = $configFile.configuration.vmStorage
    # Create VM
    New-VM -Name $VMName -MemoryStartupBytes $ram -Generation $VMGen -NewVHDPath "$VHDPath\$VMName\$VMName.vhdx" -NewVHDSizeBytes $disk -Path "$VHDPath\$VMName" -SwitchName $switch

    Write-Host "Adding DVD drive to VM..."
    # Add DVD Drive to VM
    Add-VMScsiController -VMName $VMName
    Write-Host "Adding ISO file to DVD drive..."
    $isos = $configFile.configuration.isoPath
    Add-VMDvdDrive -VMName $VMName -ControllerNumber 1 -ControllerLocation 0 -Path "$isos\$ISOFile"

    Write-Host "Configuring VM to boot from DVD drive..."
    $DVDDrive = Get-VMDvdDrive -VMName $VMName
    # Configure Virtual Machine to Boot from DVD
    Set-VMFirmware -VMName $VMName -FirstBootDevice $DVDDrive

    Write-Host "Starting VM..."
    # Start VM
    Start-VM -Name $VMName
    Write-Host "One sec..."
    Start-Sleep -s 3
    Get-VM -Name $VMName
    Write-Host "Done!"
} else {
    Write-Host "Aborting..."
}
