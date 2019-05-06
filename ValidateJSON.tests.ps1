
Describe -Name 'TestJSON Syntax' {

    $scriptFolder = Get-VstsInput -Name scriptFolder
    #For local testing
    #$JSONFiles = Get-ChildItem "c:\repo\f5productmanifest\*.json"
    $JSONFiles = Get-ChildItem "$scriptFolder\*.json"

    Foreach ($file in $JSONFiles)
    {
        $TestJSON = Get-Content -path $file
        It "$file Syntax Check Should not Throw"{
            $JSONTest = $TestJSON | Convertfrom-JSON
            $JSONTest.error | Should be $null
        }
    }
}