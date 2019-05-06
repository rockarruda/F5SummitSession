#The Code below takes the cert object from Octopus and seperates the cert and private key base64 to be used as variables further down the pipeline
#for F5 cert in the template.
$ODSP_apikey = $OctopusParameters['APIKey']
$Header = @{ "X-Octopus-ApiKey" = $ODSP_apiKey }
$thumb = $OctopusParameters['Thumbprint']
 
$getCert = $("http://myoctopus/Octopus/api/certificates/{0}" -f $thumb)
 
$cert = Invoke-RestMethod -Uri $getCert  -Headers $Header
$cert.Id

$certname = $cert.Id
 
$url = $("http://myoctopus/Octopus/api/certificates/{0}/export?format=Pem&includePrivateKey=true&pemOptions=PrimaryOnly" -f $cert.Id)

if ((Test-Path -Path "c:\certTemp") -eq $false)
{
    New-Item -Path "c:\certTemp" -ItemType Directory
}

$request = Invoke-RestMethod -Uri $url -Headers $header | Out-File C:\certTemp\f5as3.txt


$begin_certificate = '-----BEGIN CERTIFICATE-----'
$end_certificate = '-----END CERTIFICATE-----'

$begin_key = '-----BEGIN RSA PRIVATE KEY-----'
$end_key = '-----END RSA PRIVATE KEY-----'

[System.Collections.ArrayList]$certs = @()
[System.Collections.ArrayList]$keys = @()

$add_next = $false

$all_certs = Get-Content "C:\certTemp\f5as3.txt"
#$all_certs = $request.RawContent

Foreach ($line in $all_certs)
{

    if ( $line.StartsWith($begin_certificate))
    {
        $add_next = $true
        $cert_content = $begin_certificate + '\n'
        continue
    }

    if ($add_next)
    {     
        if (!$line.StartsWith($end_certificate))
        { 
            $cert_content += $line
        }
        else
        {           
            $add_next = $false     
            $cert_content += '\n' + $end_certificate       
            $certs.add($cert_content) # don't print the result of operation           
        }
    }

    if ( $line.StartsWith($begin_key))
    {
        $add_next = $true
        $keys_content = $begin_key + '\n'
        continue
    }

    if ($add_next)
    {     
        if (($line.StartsWith($end_key)) -eq $false)
        {            
            $keys_content += $line
        }
        else
        {          
            $add_next = $false     
            $keys_content += '\n' + $end_key       
            $keys.add($keys_content) # don't print the result of operation 
                      
        }
    }
}

$certs

$keys

Set-OctopusVariable -Name "CertificateName" -Value $certname

Set-OctopusVariable -Name "Certificate" -Value $certs

Set-OctopusVariable -Name "PrivateKey" -Value $keys
