$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "SAML" {
    $returnMsg = SAML
    It "Return Message" {
        $returnMsg[1] | Should -Be (gc testMessage.txt -raw -Encoding UTF8)
    }
    It "Exist Message File"{
        [System.IO.File]::Exists($returnMsg[0]) | Should -Be $true
    }
}
