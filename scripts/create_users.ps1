# create_users.ps1
# Creates employee accounts in Active Directory
# for the Corp Lab environment.

Import-Module ActiveDirectory

# Domain configuration
$domain = "corp.lab.local"
$corp = "OU=CorpLab,DC=corp,DC=lab,DC=local"

# Prompt for a starting password
$pw = Read-Host -AsSecureString "Starting password for all lab users"

# Import employee data and create accounts
Import-Csv "C:\Lab\users.csv" | ForEach-Object {

    # Generate username (example: apatel)
    $sam = ($_.FirstName.Substring(0,1) + $_.LastName).ToLower()

    # Create account parameters
    $params = @{
        Name              = "$($_.FirstName) $($_.LastName)"
        GivenName         = $_.FirstName
        Surname           = $_.LastName
        SamAccountName    = $sam
        UserPrincipalName = "$sam@$domain"
        EmailAddress      = "$sam@$domain"
        Department        = $_.Department
        Title             = $_.Title
        Path              = "OU=$($_.Department),$corp"
        AccountPassword   = $pw
        Enabled           = $true
    }

    # Create the Active Directory account
    New-ADUser @params

    # Add user to their department group
    Add-ADGroupMember -Identity "GRP-$($_.Department)" -Members $sam

    Write-Host "Created $sam in $($_.Department)"
}

# Give Ava Patel additional IT administrator access
Add-ADGroupMember -Identity "GRP-IT-Admins" -Members "apatel"

Write-Host "Employee provisioning completed!"
