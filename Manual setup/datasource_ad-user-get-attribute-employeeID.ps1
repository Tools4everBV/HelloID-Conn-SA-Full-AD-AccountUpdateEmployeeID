$UserPrincipalName = $formInput.selectedUser.UserPrincipalName
HID-Write-Status -Message "Searching AD user [$userPrincipalName]" -Event Information
 
try {
    $adUser = Get-ADuser -Filter { UserPrincipalName -eq $userPrincipalName } -Properties employeeID | Select-Object employeeID
    HID-Write-Status -Message "Finished searching AD user [$userPrincipalName]" -Event Information
    HID-Write-Summary -Message "Found AD user [$userPrincipalName]" -Event Information
     
    $employeeID = $adUser.employeeID
     
    Hid-Write-Status -Message "EmployeeID: $employeeID" -Event Information
    HID-Write-Summary -Message "EmployeeID: $employeeID" -Event Information
     
    Hid-Add-TaskResult -ResultValue @{ employeeID = $employeeID }
} catch {
    HID-Write-Status -Message "Error retrieving AD user [$userPrincipalName]. Error: $($_.Exception.Message)" -Event Error
    HID-Write-Summary -Message "Error retrieving AD user [$userPrincipalName]" -Event Failed
     
    Hid-Add-TaskResult -ResultValue []
}