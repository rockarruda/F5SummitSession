$secpasswd = ConvertTo-SecureString 'password' -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential 'azureuser', $secpasswd









#First Example of configuration push after covering AS3 Declaration components
#https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/composing-a-declaration.html#sample-declaration

#This is to illustrate a "dry-run" validation to make sure the 
#AS3 config is valid returns true if it is.

$manifestpath = "C:\github\F5SummitSession\F5summit\Manifests\BasicSample.dryrun.json"

$JSONBody = Get-Content -Path $manifestpath

$URI = "https://localhost.localdomain:8443/mgmt/shared/appsvcs/declare"

$declare = Invoke-RestMethod -Uri $URI -Method Post -Body $JSONBody -Credential $mycreds

$declare.results


#Now running the config and "deploying" it to the F5 which will 
#commit the config to the appliance

$manifestpath = "C:\github\F5SummitSession\F5summit\Manifests\BasicSample.json"

$JSONBody = Get-Content -Path $manifestpath

$URI = "https://localhost.localdomain:8443/mgmt/shared/appsvcs/declare"

$declare = Invoke-RestMethod -Uri $URI -Method Post -Body $JSONBody -Credential $mycreds

$declare.results


#Show the full schema used by AS3 from first example

$URI = "https://localhost.localdomain:8443//mgmt/shared/appsvcs/declare?show=full"

$get = Invoke-RestMethod -Uri $URI -Method Get -Credential $mycreds

$get.Sample_01 | ConvertTo-Json -Depth 4 | Out-File -FilePath "C:\github\F5Summit\f5summit\manifests\BasicSample.Full.json"



#I want to change the member in the pool from first example, 
#notice that the first node was removed, then new one added.

$manifestpath = "C:\github\F5SummitSession\F5summit\Manifests\BasicSamplechangemember.json"

$JSONBody = Get-Content -Path $manifestpath

$URI = "https://localhost.localdomain:8443/mgmt/shared/appsvcs/declare"

$declare = Invoke-RestMethod -Uri $URI -Method Post -Body $JSONBody -Credential $mycreds

$declare.results


#Now I want to add both nodes, which are shared servers

$manifestpath = "C:\github\F5SummitSession\F5summit\Manifests\BasicSamplechangememberboth.json"

$JSONBody = Get-Content -Path $manifestpath

$URI = "https://localhost.localdomain:8443/mgmt/shared/appsvcs/declare"

$declare = Invoke-RestMethod -Uri $URI -Method Post -Body $JSONBody -Credential $mycreds

$declare.results


#I want to add https monitor to the pool members

$manifestpath = "C:\github\F5SummitSession\F5summit\Manifests\BasicSampleaddmembermonitorhttps.json"

$JSONBody = Get-Content -Path $manifestpath

$URI = "https://localhost.localdomain:8443/mgmt/shared/appsvcs/declare"

$declare = Invoke-RestMethod -Uri $URI -Method Post -Body $JSONBody -Credential $mycreds

$declare.results


#Now I will add both http and https monitors for both pool members

$manifestpath = "C:\github\F5SummitSession\F5summit\Manifests\BasicSampleaddmembermonitorboth.json"

$JSONBody = Get-Content -Path $manifestpath

$URI = "https://localhost.localdomain:8443/mgmt/shared/appsvcs/declare"

$declare = Invoke-RestMethod -Uri $URI -Method Post -Body $JSONBody -Credential $mycreds

$declare.results


#I want to change the VIP name, and not use "servicemain".  
#Note the change of the template to "generic" to allow this.

$manifestpath = "C:\github\F5SummitSession\F5summit\Manifests\BasicSamplerenameVIP.json"

$JSONBody = Get-Content -Path $manifestpath

$URI = "https://localhost.localdomain:8443/mgmt/shared/appsvcs/declare"

$declare = Invoke-RestMethod -Uri $URI -Method Post -Body $JSONBody -Credential $mycreds

$declare.results


#I want to add an iRule as well as targeting a profile in the common
# partition to my configuration now

$manifestpath = "C:\github\F5SummitSession\F5summit\Manifests\BasicSampleiRule.json"

$JSONBody = Get-Content -Path $manifestpath

$URI = "https://localhost.localdomain:8443/mgmt/shared/appsvcs/declare"

$declare = Invoke-RestMethod -Uri $URI -Method Post -Body $JSONBody -Credential $mycreds

$declare.results


#Example with Cert!!

$manifestpath = "C:\github\F5SummitSession\F5summit\Manifests\BasicSample.withcert.json"

$JSONBody = Get-Content -Path $manifestpath

$URI = "https://localhost.localdomain:8443/mgmt/shared/appsvcs/declare"

$declare = Invoke-RestMethod -Uri $URI -Method Post -Body $JSONBody -Credential $mycreds

$declare.results

#Adding an additional partition for "App2"

$manifestpath = "C:\github\F5SummitSession\F5summit\Manifests\BasicSampleApp2.json"

$JSONBody = Get-Content -Path $manifestpath

$URI = "https://localhost.localdomain:8443/mgmt/shared/appsvcs/declare"

$declare = Invoke-RestMethod -Uri $URI -Method Post -Body $JSONBody -Credential $mycreds

$declare.results


#Example with Template, Insert Joke Here!! HA HA HA, seeing if you are still paying attention!! :-)

$manifestpath = "C:\github\F5SummitSession\F5summit\Manifests\F5TemplateGeneric.json"

$JSONBody = Get-Content -Path $manifestpath

$URI = "https://localhost.localdomain:8443/mgmt/shared/appsvcs/declare"

$declare = Invoke-RestMethod -Uri $URI -Method Post -Body $JSONBody -Credential $mycreds

$declare.results


#Individual delete with link below targeting the specific partition

$URI = "https://localhost.localdomain:8443/mgmt/shared/appsvcs/declare/Sample_01"

$declare = Invoke-RestMethod -Uri $URI -Method Delete -Credential $mycreds

$declare.results

#Pipeline demo.. Go over pipeline steps (mostly octopus and template from story time) Talk about the "Delete" method.. Nuke command!! with this url $URI = "https://localhost.localdomain:8443/mgmt/shared/appsvcs/declare"

#This gets rid of ALL(Can't stress this enough) partitions sent to the AS3 for declaration
$URI = "https://localhost.localdomain:8443/mgmt/shared/appsvcs/declare"

Invoke-RestMethod -Uri $URI -Method Delete -Credential $mycreds


