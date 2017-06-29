$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Create-PSModuleScaffold" {

    Mock New-Item
    Mock Copy-Item
    $Parameters = @{
        'Path' = 'C:\Windows\Temp'
        'ModuleName' = 'TestModule'
        'Author' = 'Stephen King'
        'Description' = 'Yes, Stephen King writes code now.'
    }
    Mock New-ModuleManifest

    Context 'accepting parameters' {
        It 'accepts ModuleName, Author, Path and Description strings' {
            { Create-PSModuleScaffold @Parameters } | Should Not Throw
        }
    }

    Context 'creating directory structure' {
        Create-PSModuleScaffold @Parameters
        It "create the module root directory'" {
            Assert-MockCalled New-Item -ParameterFilter { $Path.EndsWith($Parameters.ModuleName) -and $ItemType.Equals('Directory') } -Times 1 -Exactly
        }
        It "create a Src directory'" {
            Assert-MockCalled New-Item -ParameterFilter { $Path.EndsWith($Parameters.ModuleName + '-Repo\' + $Parameters.ModuleName) -and $ItemType.Equals('Directory') } -Times 1 -Exactly
        }
        It "create a Public directory'" {
            Assert-MockCalled New-Item -ParameterFilter { $Path.EndsWith('Public') -and $ItemType.Equals('Directory') } -Times 1 -Exactly
        }
        It "create a Private directory'" {
            Assert-MockCalled New-Item -ParameterFilter { $Path.EndsWith('Public') -and $ItemType.Equals('Directory') } -Times 1 -Exactly
        }
        It "create a language directory (en-us)'" {
            Assert-MockCalled New-Item -ParameterFilter { $Path.EndsWith('en-us') -and $ItemType.Equals('Directory') } -Times 1 -Exactly
        }
        It "create a tests directory'" {
            Assert-MockCalled New-Item -ParameterFilter { $Path.EndsWith('Tests') -and $ItemType.Equals('Directory') } -Times 1 -Exactly
        }
    }

    Context 'creating empty files' {
        Create-PSModuleScaffold @Parameters
        It 'create the .Format.ps1xml file' {
            Assert-MockCalled New-Item -ParameterFilter { $Path.EndsWith('.Format.ps1xml') -and $ItemType.Equals('File') } -Times 1 -Exactly
        }
        It 'create the .help.txt file' {
            Assert-MockCalled New-Item -ParameterFilter { $Path.EndsWith('.help.txt') -and $ItemType.Equals('File') } -Times 1 -Exactly
        }
        It 'create the Licence file' {
            Assert-MockCalled New-Item -ParameterFilter { $Path.EndsWith('Licence') -and $ItemType.Equals('File') } -Times 1 -Exactly
        }
        It 'create the Readme.md file' {
            Assert-MockCalled New-Item -ParameterFilter { $Path.EndsWith('README.md') -and $ItemType.Equals('File') } -Times 1 -Exactly
        }
        It 'create the AppVeyor.yml file' {
            Assert-MockCalled New-Item -ParameterFilter { $Path.EndsWith('AppVeyor.yml') -and $ItemType.Equals('File') } -Times 1 -Exactly
        }
    }

    Context 'copying template files' {
        Create-PSModuleScaffold @Parameters
        It 'copy the .psm1 file' {
            Assert-MockCalled Copy-Item -ParameterFilter { $Destination.EndsWith($Parameters.ModuleName + '.psm1') } -Times 1 -Exactly
        }
    }

    Context 'creating module maifest' {
        Create-PSModuleScaffold @Parameters
        It 'create the module manifest' {
            Assert-MockCalled New-ModuleManifest -ParameterFilter { $Path.EndsWith($Parameters.ModuleName + '.psd1') } -Times 1 -Exactly
        }
    }
}
