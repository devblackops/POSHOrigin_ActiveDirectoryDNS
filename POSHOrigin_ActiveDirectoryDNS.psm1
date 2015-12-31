#Requires -Version 5.0
#Requires -Module DnsServer

enum Ensure {
    Absent
    Present
}

[DscResource()]
class ARecord {
    [DscProperty(key)]
    [string]$Name

    [DscProperty()]
    [Ensure]$Ensure = [ensure]::Present

    [DscProperty(Mandatory)]
    [string]$DnsServer

    [DscProperty(Mandatory)]
    [pscredential]$Credential

    [DscProperty(Mandatory)]
    [string]$IPAddress

    [DscProperty(Mandatory)]
    [string]$ZoneName

    [DscProperty()]
    [int]$TTL

    [DscProperty()]
    [bool]$CreatePtr = $true

    [DscProperty()]
    [bool]$AllowUpdateAny = $false

    [DscProperty()]
    [bool]$AgeRecord = $false

    [Microsoft.Management.Infrastructure.CimSession]
    Init() {
        try {
            Import-Module -Name DnsServer -Verbose:$false -Debug:$false
            $cim = New-CimSession -ComputerName $this.DnsServer -Credential $this.Credential -Verbose:$false
            return $cim
        } catch {
            throw "Unable to establish CIM session with $($this.DnsServer)"
        }
    }

    [ARecord]Get() {
        $result = [ARecord]::new()
        try {
            $cim = $this.Init()

            $result.Name = $this.Name
            $result.Ensure = $this.Ensure
            $result.ZoneName = $this.ZoneName
            $result.DnsServer = $this.DnsServer
            $result.Credential = $this.Credential
            $result.AllowUpdateAny = $this.AllowUpdateAny
            $result.CreatePtr = $this.CreatePtr

            if ($cim) {
                $params = @{
                    RRType = 'A'
                    CimSession = $cim
                    ZoneName = $this.ZoneName
                    Name = $this.Name
                    Verbose = $false
                }
                Write-Verbose -Message "Finding [A] Record: $($this.Name) in zone $($this.ZoneName)"
                $record = Get-DnsServerResourceRecord @params -ErrorAction SilentlyContinue
                if ($record) {
                    $result.IPAddress = $record.RecordData.IPv4Address.ToString()
                    $result.AgeRecord = ($record.TimeStamp -eq $null)
                    $result.TTL = $record.TimeToLive.TotalSeconds
                } else {
                    $result.Ensure = [Ensure]::Absent
                }
                $cim | Remove-CimSession
            }
        } catch {
            Write-Error -Message 'There was a problem setting the resource'
            Write-Error -Message "$($_.InvocationInfo.ScriptName)($($_.InvocationInfo.ScriptLineNumber)): $($_.InvocationInfo.Line)"
            Write-Error -Exception $_
        }
        return $result
    }

    [void]Set() {
        $cim = $null
        try {
            $cim = $this.Init()
            $record = $this.Get()
            switch ($this.Ensure) {
                'Present' {
                    if ($record.Ensure = [ensure]::Present) {
                    
                        # Get a copy of the DNS record
                        $params = @{
                            RRType = 'A'
                            CimSession = $cim
                            ZoneName = $this.ZoneName
                            Name = $this.Name
                            Verbose = $false
                        }
                        $oldRecord = Get-DnsServerResourceRecord @params
                        $newRecord = Get-DnsServerResourceRecord @params

                        #region Resource exists but lets test if we need to change anything on it
                        $changed = $false

                        # Set IP Address
                        if ($oldRecord.RecordData.IPv4Address.ToString() -ne $this.IPAddress) {
                            $newRecord.RecordData.IPv4Address = [ipaddress]::Parse($this.IPAddress)
                            $updateParams = @{
                                NewInputObject = $newRecord
                                OldInputObject = $oldRecord
                                ZoneName = $this.ZoneName
                                CimSession = $cim
                                Confirm = $true
                            }
                            Write-Verbose -Message "Changing [A] record: $($this.Name) to IP address -> $($this.IPAddress) in zone $($this.ZoneName)"
                            Set-DnsServerResourceRecord @params
                        }

                        # Set CreatePtr
                        # TODO

                        # Set AgeRecord
                        # TODO

                        # SetAllowUpdateAny
                        # TODO

                        #endregion

                        if (-Not $changed) {
                            Write-Verbose -Message 'No changes needed'
                        }
                    } else {
                        # Create record
                        $params = @{
                            Name = $this.Name
                            ZoneName = $this.ZoneName
                            CreatePtr = $this.CreatePtr
                            IPv4Address = $this.IPAddress
                            TimeToLive = [System.TimeSpan]::FromSeconds($this.TTL)
                            AgeRecord = $this.AgeRecord
                            AllowUpdateAny = $this.AllowUpdateAny
                            CimSession = $cim
                            Verbose = $false
                        }
                        Write-Verbose -Message "Creating [A] record: $($this.Name) -> $($this.IPAddress) in zone $($this.ZoneName)"
                        Add-DnsServerResourceRecordA @params
                    }
                }
                'Absent' {
                    if ($record.Ensure = [ensure]::Present) {
                        # Delete record
                        $params = @{
                            Name = $this.Name
                            ZoneName = $this.ZoneName
                            RRType = 'A'
                            CimSession = $cim
                            Force = $true
                            Verbose = $false
                        }
                        Write-Verbose -Message "Removing [A] record: $($this.Name) ($($this.IPAddress)) from zone $($this.ZoneName)"
                        Remove-DnsServerResourceRecord @params
                    } else {
                        # Do nothing
                    }
                }
            }
        } catch {
            Write-Error -Message 'There was a problem setting the resource'
            Write-Error -Message "$($_.InvocationInfo.ScriptName)($($_.InvocationInfo.ScriptLineNumber)): $($_.InvocationInfo.Line)"
            Write-Error -Exception $_
            $cim | Remove-CimSession
        }
        
    }

    [bool]Test() {
        $record = $this.Get()
        $pass = $true
        switch($this.Ensure) {
            'Present' {
                if ($record.Ensure -eq [ensure]::Present) {
                    # Record exists, does it have the correct settings?
                    Write-Verbose -Message 'Record exists'
                } else {
                    Write-Verbose -Message 'Record does not exist'
                    $pass = $false
                }
            }
            'Absent' {
                if ($record.Ensure -eq [ensure]::Absent) {
                    Write-Verbose -Message 'Record does not exist'
                } else {
                    Write-Verbose -Message 'Record exists'
                    $pass = $false
                }
            }
        }
        return $false
    }
}