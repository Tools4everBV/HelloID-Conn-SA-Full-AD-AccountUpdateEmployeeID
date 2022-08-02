$userPrincipalName = $form.gridUsers.UserPrincipalName
$employeeID = $form.employeeID

try {
    $adUser = Get-ADuser -Filter { UserPrincipalName -eq $userPrincipalName }
    Write-Information "Found AD user [$userPrincipalName]"
} catch {
    Write-Error "Could not find AD user [$userPrincipalName]. Error: $($_.Exception.Message)"    
}

try {
    If($employeeID.Length -lt 1){
        Set-ADUser -Identity $adUSer -Clear employeeID
    } else{
        Set-ADUser -Identity $adUSer -employeeID $employeeID
    }
    Write-Information "Finished update attribute [employeeID] of AD user [$userPrincipalName] to [$employeeID]"
    $Log = @{
            Action            = "UpdateAccount" # optional. ENUM (undefined = default) 
            System            = "ActiveDirectory" # optional (free format text) 
            Message           = "Successfully updated attribute [employeeID] of AD user [$userPrincipalName] to [$employeeID]" # required (free format text) 
            IsError           = $false # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
            TargetDisplayName = $adUser.name # optional (free format text) 
            TargetIdentifier  = $([string]$adUser.SID) # optional (free format text) 
        }
    #send result back  
    Write-Information -Tags "Audit" -MessageData $log
    
} catch {
    Write-Error "Could not update attribute [employeeID] of AD user [$userPrincipalName] to [$employeeID]. Error: $($_.Exception.Message)"
    $Log = @{
            Action            = "UpdateAccount" # optional. ENUM (undefined = default) 
            System            = "ActiveDirectory" # optional (free format text) 
            Message           = "Failed to update attribute [employeeID] of AD user [$userPrincipalName] to [$employeeID]" # required (free format text) 
            IsError           = $true # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
            TargetDisplayName = $adUser.name # optional (free format text) 
            TargetIdentifier  = $([string]$adUser.SID) # optional (free format text) 
        }
    #send result back  
    Write-Information -Tags "Audit" -MessageData $log    
}
