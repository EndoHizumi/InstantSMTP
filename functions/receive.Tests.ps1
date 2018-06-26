$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = "Get-MailMessage.ps1"
. "$here\$sut"

Describe "receive" {
    $inMessage = "HELO`r`n"
    $stream = [System.IO.MemoryStream]::new([System.Text.Encoding]::UTF8.GetBytes($inMessage))
    It "Return String" {
        $script:isReceiveState = $true
        receive $stream | Should -be "HELO`r`n"
    }
    It "Return Array" {
        $stream.Position = 0
        $script:isReceiveState = $false
        $result = (Compare-Object (receive $stream) @("HELO"))
        $result.count | Should -be 0
    }
}