$guid = New-Guid

$F5ID = $guid.guid

Write-Output "Creating AS3 config ID: $F5ID"

Set-OctopusVariable -Name "AS3Guid" -Value $F5ID