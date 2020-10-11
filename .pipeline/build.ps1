[CmdletBinding()]
param(
    [switch] $Compile,

    [switch] $Test,

    [switch] $Analyze,

    [string] $Module,

    [string] $BasePath
)

# Compile step
if ($Compile.IsPresent) {
    if (Get-Module $Module) {
        Remove-Module $Module -Force
    }

    if ((Test-Path "$BasePath\$Module")) {
        Remove-Item -Path "$BasePath\$Module" -Recurse -Force
    }

    if (-not (Test-Path "$BasePath\$Module")) {
        $null = New-Item -Path "$BasePath\$Module" -ItemType Directory
    }

    Copy-Item -Path "$BasePath\src\*" -Filter '*.*' -Exclude '*.ps1', '*.psm1', '*.template' -Recurse -Destination "$BasePath\$Module" -Force

    if ((Test-Path "$BasePath\$Module\Private")) {
        Remove-Item -Path "$BasePath\$Module\Private" -Recurse -Force
    }
    #Remove-Item -Path "$BasePath\$Module\Public" -Recurse -Force

    # Copy Module README file
    #Copy-Item -Path "$BasePath\README.md" -Destination "$BasePath\$Module" -Force

    if ((Test-Path "$BasePath\src\Functions")) {
        Get-ChildItem -Path "$BasePath\src\Functions\*.ps1" -Recurse | Get-Content | Add-Content "$BasePath\$Module\$Module.psm1"
    }

    $Public  = @( Get-ChildItem -Path "$BasePath\src\Functions\*.ps1" -ErrorAction SilentlyContinue )

    $Public | Get-Content | Add-Content "$BasePath\$Module\$Module.psm1"

    "Export-ModuleMember -Function '$($Public.BaseName -join "', '")'" | Add-Content "$BasePath\$Module\$Module.psm1"
}

# Test step
if($Test.IsPresent) {
    if (-not (Get-Module -Name Pester -ListAvailable) -or (Get-Module -Name Pester -ListAvailable)[0].Version -eq [Version]'3.4.0') {
        Write-Warning "Module 'Pester' is missing or out of date. Installing 'Pester' ..."
        Install-Module -Name Pester -Scope CurrentUser -Force
    }

    if (-not (Get-Module -Name PoshBot -ListAvailable)) {
        Write-Warning "Module 'PoshBot' is missing or out of date. Installing 'PoshBot' ..."
        Install-Module -Name PoshBot -Scope CurrentUser -Force
    }

    $Result = Invoke-Pester "$BasePath\test" -OutputFormat NUnitXml -OutputFile TestResults.xml -PassThru

    if ($Result.FailedCount -gt 0) {
        throw "$($res.FailedCount) tests failed."
    }
}

if($Analyze.IsPresent) {
    if (-not (Get-Module -Name PSScriptAnalyzer -ListAvailable)) {
        Write-Warning "Module 'PSScriptAnalyzer' is missing. Installing 'PSScriptAnalyzer' ..."
        Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force
    }

    Invoke-ScriptAnalyzer -Path "$BasePath" -Recurse -EnableExit
}