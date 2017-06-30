# Create-PSModuleScaffold
Scaffold a folder structure for a new PowerShell module

## Install
Dot source into the current session:

  . .\Create-PSModuleScaffold.ps1
  
Or add to the powershell profile:

https://blogs.technet.microsoft.com/heyscriptingguy/2012/05/21/understanding-the-six-powershell-profiles/

## Usage

### Example

Create-PSModuleScaffold -ModuleName 'NewModuleName' -Author 'Mark Allen' -Path 'C:\Dev\Modules' -Description 'New module'
