$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = "Get-MailMessage.ps1"
. "$here\$sut"

Describe "responce" {
    $inMessage = "250 OK"
    $stream = [System.IO.MemoryStream]::new()
    [byte[]] $readBytes = New-Object byte[] 8
    It "Return String" {
        responce $inMessage $stream 
        $stream.position = 0
        $stream.Read($readBytes, 0, $readBytes.Length)
        [System.Text.Encoding]::UTF8.GetString($readBytes) | Should -be "250 OK`r`n"
    }
}