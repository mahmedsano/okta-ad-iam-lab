# access_report.ps1 - who has access to what, plus failed sign-ins

$org = $env:OKTA_ORG

$headers = @{
    Authorization = "SSWS $($env:OKTA_TOKEN)"
    Accept = "application/json"
}

$staleDays = 30

# 1. Every user, with their groups and apps

$users = Invoke-RestMethod -Uri "$org/api/v1/users?limit=200" -Headers $headers

$report = foreach ($u in $users) {

    $groups = (Invoke-RestMethod -Uri "$org/api/v1/users/$($u.id)/groups" -Headers $headers).profile.name

    $apps = (Invoke-RestMethod -Uri "$org/api/v1/users/$($u.id)/appLinks" -Headers $headers).label

    $flags = @()

    if (-not $u.lastLogin) {
        $flags += "NEVER-SIGNED-IN"
    }
    elseif (((Get-Date) - [datetime]$u.lastLogin).Days -gt $staleDays) {
        $flags += "STALE-$staleDays-DAYS"
    }

    if ($groups -contains "GRP-IT-Admins") {
        $flags += "ADMIN"
    }

    if ($u.status -ne "ACTIVE") {
        $flags += $u.status
    }

    [pscustomobject]@{
        Login      = $u.profile.login
        Department = $u.profile.department
        Status     = $u.status
        LastLogin  = $u.lastLogin
        Groups     = ($groups -join "; ")
        Apps       = ($apps -join "; ")
        Flags      = ($flags -join ", ")
    }
}

$report | Export-Csv C:\Lab\access_report.csv -NoTypeInformation

Write-Host "Access report: $($report.Count) users -> C:\Lab\access_report.csv"


# 2. Failed sign-ins in the last 7 days, from the Okta System Log

$since = (Get-Date).ToUniversalTime().AddDays(-7).ToString("yyyy-MM-ddTHH:mm:ssZ")

$filter = [uri]::EscapeDataString('outcome.result eq "FAILURE"')

$events = Invoke-RestMethod -Uri "$org/api/v1/logs?since=$since&filter=$filter&limit=1000" -Headers $headers

$events | ForEach-Object {
    [pscustomobject]@{
        Time      = $_.published
        User      = $_.actor.alternateId
        Event     = $_.eventType
        Reason    = $_.outcome.reason
        IPAddress = $_.client.ipAddress
    }
} | Export-Csv C:\Lab\failed_signins.csv -NoTypeInformation

Write-Host "Failed events: $($events.Count) -> C:\Lab\failed_signins.csv"
