$ErrorActionPreference="stop"
"$PSScriptRoot\functions\*.ps1" |
Resolve-Path|
Where-Object{!$_.path.Tolower().contains(".tests.")} |
ForEach-Object{
    .$_.path
}
