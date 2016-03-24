##Requires -Version 5.0
##Requires -Module DnsServer

#enum Ensure {
#    Absent
#    Present
#}

#[DscResource()]
#class ARecord {
#    [DscProperty(key)]
#    [string]$Name

#    [DscProperty()]
#    [Ensure]$Ensure = [ensure]::Present

#    [DscProperty(Mandatory)]
#    [string]$DnsServer

#    [DscProperty(Mandatory)]
#    [pscredential]$Credential

#    [DscProperty(Mandatory)]
#    [string]$IPAddress

#    [DscProperty(Mandatory)]
#    [string]$ZoneName

#    [DscProperty()]
#    [int]$TTL

#    [DscProperty()]
#    [bool]$CreatePtr = $true

#    [DscProperty()]
#    [bool]$AllowUpdateAny = $false

#    [DscProperty()]
#    [bool]$AgeRecord = $false

#    [Microsoft.Management.Infrastructure.CimSession]
#    Init() {
#        try {
#            Import-Module -Name DnsServer -Verbose:$false -Debug:$false
#            $cim = New-CimSession -ComputerName $this.DnsServer -Credential $this.Credential -Verbose:$false
#            return $cim
#        } catch {
#            throw "Unable to establish CIM session with $($this.DnsServer)"
#        }
#    }

#    [ARecord]Get() {
#        $result = [ARecord]::new()
#        try {
#            $cim = $this.Init()

#            $result.Name = $this.Name
#            $result.ZoneName = $this.ZoneName
#            $result.DnsServer = $this.DnsServer
#            $result.Credential = $this.Credential
#            $result.AllowUpdateAny = $this.AllowUpdateAny
#            $result.CreatePtr = $this.CreatePtr

#            $params = @{
#                RRType = 'A'
#                CimSession = $cim
#                ZoneName = $this.ZoneName
#                Name = $this.Name
#                Verbose = $false
#            }
#            Write-Verbose -Message "Finding Record: $($this.Name) in zone $($this.ZoneName)"
#            $record = Get-DnsServerResourceRecord @params -ErrorAction SilentlyContinue
#            if ($record) {
#                $result.Ensure = [Ensure]::Present
#                $result.IPAddress = $record.RecordData.IPv4Address.ToString()
#                $result.AgeRecord = ($record.TimeStamp -ne $null)
#                $result.TTL = $record.TimeToLive.TotalSeconds
#            } else {
#                $result.Ensure = [Ensure]::Absent
#            }
#            $cim | Remove-CimSession
#        } catch {
#            Write-Error -Message 'There was a problem getting the resource'
#            Write-Error -Message "$($_.InvocationInfo.ScriptName)($($_.InvocationInfo.ScriptLineNumber)): $($_.InvocationInfo.Line)"
#            Write-Error -Exception $_
#        }
#        return $result
#    }

#    [void]Set() {
#        $cim = $null
#        try {
#            $cim = $this.Init()
#            $record = $this.Get()
#            switch ($this.Ensure) {
#                'Present' {

#                    # Does the record already exist?
#                    if ($record.Ensure -eq [ensure]::Present) {
                    
#                        # Get a copy of the DNS record
#                        $params = @{
#                            RRType = 'A'
#                            CimSession = $cim
#                            ZoneName = $this.ZoneName
#                            Name = $this.Name
#                            Verbose = $false
#                        }
#                        $oldRecord = Get-DnsServerResourceRecord @params
#                        $newRecord = Get-DnsServerResourceRecord @params

#                        #region Resource exists but lets test if we need to change anything on it
#                        $changed = $false

#                        # Set IP Address
#                        if ($oldRecord.RecordData.IPv4Address.ToString() -ne $this.IPAddress) {
#                            $newRecord.RecordData.IPv4Address = [ipaddress]::Parse($this.IPAddress)
#                            $updateParams = @{
#                                NewInputObject = $newRecord
#                                OldInputObject = $oldRecord
#                                ZoneName = $this.ZoneName
#                                CimSession = $cim
#                                Confirm = $true
#                            }
#                            Write-Verbose -Message "Changing record: $($this.Name) to IP address -> $($this.IPAddress) in zone $($this.ZoneName)"
#                            Set-DnsServerResourceRecord @params
#                        }

#                        # Set CreatePtr
#                        # TODO

#                        # Set AgeRecord
#                        # TODO

#                        # SetAllowUpdateAny
#                        # TODO

#                        #endregion

#                        if (-Not $changed) {
#                            Write-Verbose -Message 'No changes needed'
#                        }
#                    } else {
#                        # Create record
#                        $params = @{
#                            Name = $this.Name
#                            ZoneName = $this.ZoneName
#                            CreatePtr = $this.CreatePtr
#                            IPv4Address = $this.IPAddress
#                            TimeToLive = [System.TimeSpan]::FromSeconds($this.TTL)
#                            AgeRecord = $this.AgeRecord
#                            AllowUpdateAny = $this.AllowUpdateAny
#                            CimSession = $cim
#                            Verbose = $false
#                        }
#                        Write-Verbose -Message "Creating record: $($this.Name) -> $($this.IPAddress) in zone $($this.ZoneName)"
#                        Add-DnsServerResourceRecordA @params
#                    }
#                }
#                'Absent' {
#                    if ($record.Ensure = [ensure]::Present) {
#                        # Delete record
#                        $params = @{
#                            Name = $this.Name
#                            ZoneName = $this.ZoneName
#                            RRType = 'A'
#                            CimSession = $cim
#                            Force = $true
#                            Verbose = $false
#                        }
#                        Write-Verbose -Message "Removing record: $($this.Name) ($($this.IPAddress)) from zone $($this.ZoneName)"
#                        Remove-DnsServerResourceRecord @params
#                    } else {
#                        # Do nothing
#                    }
#                }
#            }
#        } catch {
#            Write-Error -Message 'There was a problem setting the resource'
#            Write-Error -Message "$($_.InvocationInfo.ScriptName)($($_.InvocationInfo.ScriptLineNumber)): $($_.InvocationInfo.Line)"
#            Write-Error -Exception $_
#            $cim | Remove-CimSession
#        }
#    }

#    [bool]Test() {
#        $record = $this.Get()
#        Write-Verbose -Message "Validating that record $($this.Name) in $($this.ZoneName) is $($this.Ensure.ToString().ToLower())"        
#        if ($this.Ensure -ne $record.Ensure) { return $false }
#        elseif ($this.Ensure -eq [ensure]::Present -and ($record.IPAddress -ne $this.IPAddress)) { return $false }
#        return $true
#    }
#}

#[DscResource()]
#class CName {
#    [DscProperty(key)]
#    [string]$Name

#    [DscProperty()]
#    [Ensure]$Ensure = [ensure]::Present

#    [DscProperty(Mandatory)]
#    [string]$DnsServer

#    [DscProperty(Mandatory)]
#    [pscredential]$Credential

#    [DscProperty(Mandatory)]
#    [string]$ZoneName

#    [DscProperty(Mandatory)]
#    [string]$FQDN

#    [DscProperty()]
#    [int]$TTL

#    [DscProperty()]
#    [bool]$AllowUpdateAny = $false

#    [DscProperty()]
#    [bool]$AgeRecord = $false

#    [Microsoft.Management.Infrastructure.CimSession]
#    Init() {
#        try {
#            Import-Module -Name DnsServer -Verbose:$false -Debug:$false
#            $cim = New-CimSession -ComputerName $this.DnsServer -Credential $this.Credential -Verbose:$false
#            return $cim
#        } catch {
#            throw "Unable to establish CIM session with $($this.DnsServer)"
#        }
#    }

#    [CName]Get() {
#        $result = [Cname]::new()
#        try {
#            $record = $null
#            $cim = $this.Init()

#            $result.Name = $this.Name
#            $result.ZoneName = $this.ZoneName
#            $result.DnsServer = $this.DnsServer
#            $result.Credential = $this.Credential
#            $result.AllowUpdateAny = $this.AllowUpdateAny

#            $params = @{
#                RRType = 'CNAME'
#                CimSession = $cim
#                ZoneName = $this.ZoneName
#                Name = $this.Name
#                Verbose = $false
#            }
#            Write-Verbose -Message "Finding record: $($this.Name) in zone $($this.ZoneName)"
#            $record = Get-DnsServerResourceRecord @params -ErrorAction SilentlyContinue
#            if ($record) {
#                $result.Ensure = [Ensure]::Present
#                $result.FQDN = $record.RecordData.HostNameAlias.TrimEnd('.')
#                $result.AgeRecord = ($record.TimeStamp -ne $null)
#                $result.TTL = $record.TimeToLive.TotalSeconds
#            } else {
#                $result.Ensure = [Ensure]::Absent
#            }
#            $cim | Remove-CimSession
#        } catch {
#            Write-Error -Message 'There was a problem getting the resource'
#            Write-Error -Message "$($_.InvocationInfo.ScriptName)($($_.InvocationInfo.ScriptLineNumber)): $($_.InvocationInfo.Line)"
#            Write-Error -Exception $_
#        }
#        return $result
#    }

#    [void]Set() {
#        $cim = $null
#        try {
#            $cim = $this.Init()
#            $record = $this.Get()
#            switch ($this.Ensure) {
#                'Present' {
                    
#                    # Does the record already exist?
#                    if ($record.Ensure -eq [ensure]::Present) {
                    
#                        # Get a copy of the DNS record
#                        $params = @{
#                            RRType = 'CName'
#                            CimSession = $cim
#                            ZoneName = $this.ZoneName
#                            Name = $this.Name
#                            Verbose = $false
#                        }
#                        $oldRecord = Get-DnsServerResourceRecord @params
#                        $newRecord = Get-DnsServerResourceRecord @params

#                        #region Resource exists but lets test if we need to change anything on it
#                        $changed = $false

#                        # Set IP Address
#                        $oldHostNameAlias= oldRecord.RecordData.HostNameAlias.TrimEnd('.')
#                        if ($oldHostNameAlias -ne $this.FQDN) {
#                            $newRecord.RecordData.HostNameAlias = $this.FQDN
#                            $updateParams = @{
#                                NewInputObject = $newRecord
#                                OldInputObject = $oldRecord
#                                ZoneName = $this.ZoneName
#                                CimSession = $cim
#                                Confirm = $true
#                            }
#                            Write-Verbose -Message "Changing record: $($this.Name) FQDN -> $($this.FQDN)"
#                            Set-DnsServerResourceRecord @params
#                        }

#                        # Set AgeRecord
#                        # TODO

#                        # SetAllowUpdateAny
#                        # TODO

#                        #endregion

#                        if (-Not $changed) {
#                            Write-Verbose -Message 'No changes needed'
#                        }
#                    } else {
#                        # Create record
#                        $params = @{
#                            Name = $this.Name
#                            ZoneName = $this.ZoneName
#                            HostNameAlias = $this.FQDN
#                            TimeToLive = [System.TimeSpan]::FromSeconds($this.TTL)
#                            AgeRecord = $this.AgeRecord
#                            AllowUpdateAny = $this.AllowUpdateAny
#                            CimSession = $cim
#                            Verbose = $false
#                        }
#                        Write-Verbose -Message "Creating record: $($this.Name) -> $($this.FQDN) in zone $($this.ZoneName)"
#                        Add-DnsServerResourceRecordCName @params
#                    }
#                }
#                'Absent' {
#                    if ($record.Ensure = [ensure]::Present) {
#                        # Delete record
#                        $params = @{
#                            Name = $this.Name
#                            ZoneName = $this.ZoneName
#                            RRType = 'CName'
#                            CimSession = $cim
#                            Force = $true
#                            Verbose = $false
#                        }
#                        Write-Verbose -Message "Removing record: $($this.Name) ($($this.FQDN)) from zone $($this.ZoneName)"
#                        Remove-DnsServerResourceRecord @params
#                    } else {
#                        # Do nothing
#                    }
#                }
#            }
#        } catch {
#            Write-Error -Message 'There was a problem setting the resource'
#            Write-Error -Message "$($_.InvocationInfo.ScriptName)($($_.InvocationInfo.ScriptLineNumber)): $($_.InvocationInfo.Line)"
#            Write-Error -Exception $_
#            $cim | Remove-CimSession
#        }
#    }

#    [bool]Test() {
#        $record = $this.Get()
#        Write-Verbose -Message "Validating that record $($this.Name) in $($this.ZoneName) is $($this.Ensure.ToString().ToLower())"
#        if ($this.Ensure -ne $record.Ensure) { return $false }
#        elseif ($this.Ensure -eq [ensure]::Present -and ($record.FQDN -ne $this.FQDN)) { return $false }
#        return $true
#    }
#}