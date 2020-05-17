$WinMajorVersion = (Get-CimInstance -ClassName Win32_OperatingSystem -Property Version).Version.Split('.')[0]

if ($WinMajorVersion -ge 10) {
    $Functions = @( Get-ChildItem -Path $PSScriptRoot\functions\*.ps1 -ErrorAction SilentlyContinue )

    foreach ($Import in @($Functions)) {
        try {
            . $Import.FullName
        } catch {
            Write-Error -Message "Failed to import function $($Import.FullName): $_"
        }
    }
}