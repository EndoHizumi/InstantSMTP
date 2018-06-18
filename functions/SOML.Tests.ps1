$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "SOML" {
    $returnMsg = SOML
    It "Return Message" {
        $returnMsg | Should -Be (gc testMessage.txt -raw -Encoding UTF8)
    }
}
