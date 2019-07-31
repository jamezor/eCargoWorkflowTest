param([Parameter(Mandatory)]$UserName, [Parameter(Mandatory)]$Password)

$ErrorActionPreference = 'Stop'

$localBranch = Get-CurrentBranchName
$tempBranch = "temp/pre-commit-check-$([Guid]::NewGuid())"

# because the status can only be set when github knows the commit hash
Invoke-ExecutableWithCommand "git push origin $($localBranch):$($tempBranch)"

try {
    $newestHash = Invoke-ExecutableWithCommand "git log '@{u}..' --format=%H -1"

    $pair = "$($UserName):$($Password)"
    $encodedCredentials = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($Pair))
    $headers = @{ Authorization = "Basic $encodedCredentials" }

    # set status
    $response = Invoke-RestMethod -Uri "https://api.github.com/repos/jamezor/eCargoWorkflowTest/statuses/$newestHash" -Method Post -Headers $headers -Body (ConvertTo-Json @{ state = "success"; context = "pre-commit-check"; description = "Pre-commit check succeeded" } ) -ContentType "application/json"

    Invoke-ExecutableWithCommand "git push"
}
finally {
    Invoke-ExecutableWithCommand "git push origin :$($tempBranch)"
}
