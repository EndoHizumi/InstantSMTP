$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.ps1', '.psm1'

$global:expect = @(
"DATA",
"EHLO",
"EXPN",
"Get-MailMessage",
"HELO",
"Initialize-Status",
"MAIL",
"NOOP",
"QUIT",
"RCPT",
"receive",
"responce",
"RSET",
"SAML",
"SEND",
"Show-Status",
"SOML",
"TURN",
"VRFY"
)

Describe "InstantSMTP" {
    It "Import All Module" {
        Import-Module "$here\$sut" -Force
        $global:actual = (Get-ChildItem "function:" | Where-Object{$_.source.Contains("InstantSMTP")} | Select-Object name).name
        (Compare-Object $expect $actual).count | Should -Be 0
    }
}
