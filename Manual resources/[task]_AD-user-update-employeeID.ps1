try {
    $adUser = Get-ADuser -Filter { UserPrincipalName -eq $userPrincipalName }
    HID-Write-Status -Message "Found AD user [$userPrincipalName]" -Event Information
    HID-Write-Summary -Message "Found AD user [$userPrincipalName]" -Event Information
} catch {
    HID-Write-Status -Message "Could not find AD user [$userPrincipalName]. Error: $($_.Exception.Message)" -Event Error
    HID-Write-Summary -Message "Failed to find AD user [$userPrincipalName]" -Event Failed
}

try {
    Set-ADUser -Identity $adUSer -employeeID $employeeID
    HID-Write-Status -Message "Finished update attribute [employeeID] of AD user [$userPrincipalName] to [$employeeID]" -Event Success
    HID-Write-Summary -Message "Successfully updated attribute [employeeID] of AD user [$userPrincipalName] to [$employeeID]" -Event Success
} catch {
    HID-Write-Status -Message "Could not update attribute [employeeID] of AD user [$userPrincipalName] to [$employeeID]. Error: $($_.Exception.Message)" -Event Error
    HID-Write-Summary -Message "Failed to update attribute [employeeID] of AD user [$userPrincipalName] to [$employeeID]" -Event Failed
}
