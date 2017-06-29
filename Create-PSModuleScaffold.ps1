function Create-PSModuleScaffold {
    param(
        # Name of the new module
        [Parameter(Mandatory)]
        [string]
        $ModuleName,
        # Author name
        [Parameter(Mandatory)]
        [string]
        $Author,
        # Author name
        [Parameter(Mandatory)]
        [ValidateScript({Test-Path $(Split-Path $_) -PathType 'Container'})] 
        [string]
        $Path,
        # Module description
        [Parameter(Mandatory)]
        [string]
        $Description
    )
    Begin {
    }
    
    Process {
        $Path="$Path\$ModuleName-Repo"
        # Create the module and private function directories
        $Directories = @($ModuleName,"$ModuleName\Private","$ModuleName\Public","$ModuleName\en-us","Tests")
        $Directories | ForEach-Object { New-Item -Path "$Path\$_" -ItemType Directory }

        #Create the module and related files
        $Files = @(
            "$ModuleName\$ModuleName.Format.ps1xml",
            "$ModuleName\en-US\about_PSStackExchange.help.txt",
            "Tests\$ModuleName.Tests.ps1",
            "Licence",
            ".gitignore",
            "README.md",
            "AppVeyor.yml"
        )
        $Files | ForEach-Object { New-Item -Path "$Path\$_" -ItemType File }

        # Copy the base psm1 file
        Copy-Item "$PSScriptRoot\PSModuleScaffold.psm1" "$Path\$ModuleName\$ModuleName.psm1"
    }

    End {
        # Create the module manifest
        New-ModuleManifest -Path "$Path\$ModuleName\$ModuleName.psd1" `
            -RootModule "$Path\$ModuleName\$ModuleName.psm1" `
            -Description "$Description" `
            -PowerShellVersion 3.0 `
            -Author "$Author" `
            -FormatsToProcess "$ModuleName.Format.ps1xml"
    }
}
#Create-PSModuleScaffold -ModuleName "CMCollectionAnalyzer" -Author "Mark Allen" -Path $pwd -Description "Analyze ConfigMgr collections for configurations that may cause site or heirachy performance issues"