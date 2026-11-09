# jml.ps1 - Joiner / Mover / Leaver automation for Corp Lab

param([string]$FeedPath = "C:\Lab\hr_feed.csv")

Import-Module ActiveDirectory

$domain = "corp.lab.local"
$corp = "OU=CorpLab,DC=corp,DC=lab,DC=local"
$disabledOU = "OU=Disabled Users,$corp"
$logFile = "C:\Lab\jml_log.csv"

# Write one line to the audit log
function Write-Log($Action, $User, $Detail) {
    [pscustomobject]@{
        Time   = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Action = $Action
        User   = $User
        Detail = $Detail
    } | Export-Csv $logFile -Append -NoTypeInformation

    Write-Host "[$Action] $User - $Detail"
}

# Ask Okta to end all of a user's sessions immediately
function Revoke-OktaSessions($Login) {
    if (-not $env:OKTA_TOKEN) {
        Write-Log "Okta-Skip" $Login "No API token set"
        return
    }

    $headers = @{
        Authorization = "SSWS $($env:OKTA_TOKEN)"
        Accept = "application/json"
    }

    try {
        $user = Invoke-RestMethod -Uri "$($env:OKTA_ORG)/api/v1/users/$Login" -Headers $headers

        Invoke-RestMethod -Method Delete -Uri "$($env:OKTA_ORG)/api/v1/users/$($user.id)/sessions" -Headers $headers

        Write-Log "Okta-Sessions-Revoked" $Login "All active sessions ended"
    }
    catch {
        Write-Log "Okta-Error" $Login $_.Exception.Message
    }
}

foreach ($row in Import-Csv $FeedPath) {

    $sam = ($row.FirstName.Substring(0,1) + $row.LastName).ToLower()

    $existing = Get-ADUser -Filter "SamAccountName -eq '$sam'" -Properties Department, MemberOf

    if ($row.Action -eq "Join") {

        if ($existing) {
            Write-Log "Join-Skipped" $sam "Account already exists"
            continue
        }

        # Temporary password (lab only)
        $temp = "Welcome-" + (Get-Random -Minimum 100000 -Maximum 999999) + "!"

        $params = @{
            Name = "$($row.FirstName) $($row.LastName)"
            GivenName = $row.FirstName
            Surname = $row.LastName
            SamAccountName = $sam
            UserPrincipalName = "$sam@$domain"
            EmailAddress = "$sam@$domain"
            Department = $row.Department
            Title = $row.Title
            Path = "OU=$($row.Department),$corp"
            AccountPassword = (ConvertTo-SecureString $temp -AsPlainText -Force)
            Enabled = $true
        }

        New-ADUser @params

        Add-ADGroupMember -Identity "GRP-$($row.Department)" -Members $sam

        Write-Log "Join" $sam "Created in $($row.Department), added to GRP-$($row.Department)"

        Write-Host "Temporary password for ${sam}: $temp"
    }

    elseif ($row.Action -eq "Move") {

        if (-not $existing) {
            Write-Log "Move-Failed" $sam "User not found"
            continue
        }

        $oldDept = $existing.Department

        Remove-ADGroupMember -Identity "GRP-$oldDept" -Members $sam -Confirm:$false

        Add-ADGroupMember -Identity "GRP-$($row.Department)" -Members $sam

        Set-ADUser $sam -Department $row.Department -Title $row.Title

        Move-ADObject -Identity $existing.DistinguishedName -TargetPath "OU=$($row.Department),$corp"

        Write-Log "Move" $sam "$oldDept -> $($row.Department); removed GRP-$oldDept, added GRP-$($row.Department)"
    }

    elseif ($row.Action -eq "Leave") {

        if (-not $existing) {
            Write-Log "Leave-Failed" $sam "User not found"
            continue
        }

        Disable-ADAccount -Identity $sam

        foreach ($group in $existing.MemberOf) {
            Remove-ADGroupMember -Identity $group -Members $sam -Confirm:$false
        }

        Set-ADUser $sam -Description "Disabled $(Get-Date -Format yyyy-MM-dd) by JML script"

        Move-ADObject -Identity $existing.DistinguishedName -TargetPath $disabledOU

        Write-Log "Leave" $sam "Disabled, removed from $($existing.MemberOf.Count) groups, moved to Disabled Users"

        Revoke-OktaSessions "$sam@$domain"
    }

    else {
        Write-Log "Unknown-Action" $sam "Action '$($row.Action)' not recognized"
    }
}
