#This test will validate the config file contains the required AS3 config fields

Describe -Name 'Validate AS3 Configuration Tests' {

    #Below variable is used to pass Azure DevOps variable into Pester Test
    $folder =  "$($env:Build_SourcesDirectory)\Manifests"
    #For local testing
    #$JSONFiles = Get-ChildItem "c:\repo\f5productmanifest\*.json"
    $JSONFiles = Get-ChildItem "$folder\*.json"

    Context -Name 'Validate Required Schema Parents' {

        Foreach ($file in $JSONFiles)
        {
            $content = Get-Content $file | ConvertFrom-Json

            It "Should return AS3 for Class for $file" {
                $content.class | Should -Be 'AS3'
            }

            It "Should return True for Persist for $file" {
                $content.Persist | Should -Be 'True'
            }

            It "Should return True for Declaration for $file" {
                $content.Declaration | Should -Not -BeNullOrEmpty
            }

            It "Should return Deploy for Action for $file" {
                $content.Action | Should -Be 'deploy'
            }

        }
    }

    Context -Name 'Validate Required Schema Child Items' {

        Foreach ($file in $JSONFiles)
        {
            $content = Get-Content $file | ConvertFrom-Json

            It "Should return ADC for Declaration Class for $file" {
                $content.Declaration.class | Should -Be 'ADC'
            }

            It "Should return 3.8.0 for Declaration Schema Version for $file" {
                $content.Declaration.schemaversion| Should -Be '3.8.0'
            }

            It "Should return an ID for Declaration ID for $file" {
                $content.Declaration.id | Should -Not -BeNullOrEmpty
            }

            It "Should return generic for the template for $file" {
                $content.declaration.'#{ApplicationName}_#{EnvironmentType}'.'#{ApplicationName}'.template | Should -Be 'generic'
            }
        }
    }

}