$ODSP_FileName = $OctopusParameters['FileName']
$ODSP_F5ManifestDirectory = $OctopusParameters['F5ManifestDirectory']
$ODSP_F5UserName = $OctopusParameters['F5UserName']
$ODSP_F5Password = $OctopusParameters['F5Password']
$ODSP_FileName
$ODSP_F5ManifestDirectory
$AppName = $OctopusParameters['ApplicationName']
$Env = $OctopusParameters['EnvironmentType']
$SeqCICDServicesApiKey = $OctopusParameters['SeqKey']
$SeqUrlCICDLogging = $OctopusParameters['SeqUrl']

$URI = "https://myf5/mgmt/shared/appsvcs/declare"

#These lines are sent to central logging for audit purposes
#$initiator = '#{Octopus.Deployment.CreatedBy.EmailAddress}'
#$seqProperties = @{Area = "F5AS3Config"} | convertto-json
#$messageTemplate = $("Sending Configuration to F5 for Application: {0}, Environment Created: {1} . Initiated by: {2} via Octopus Pipeline to create a virtual environment." -f $AppName, $Env, $initiator)

#Force tls1.2 and disable "Expect:100 Continue"
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
[System.Net.ServicePointManager]::Expect100Continue = $false

#Stores F5 cred in secure string..  Demo purpose only, really use a password vault to pull creds from and not variable in octopus
$secpasswd = ConvertTo-SecureString $ODSP_F5Password -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential $ODSP_F5UserName, $secpasswd

#Load json manifest into variable to be passed into invoke-restmethod cmdlet       
$JSONBody = Get-Content -Path "$ODSP_F5ManifestDirectory\$ODSP_$FileName"

$JSONBody

$declare = Invoke-RestMethod -Uri $URI -Method Post -Body $JSONBody -Credential $mycreds

$declare.results

