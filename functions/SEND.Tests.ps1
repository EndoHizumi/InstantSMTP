$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
$toAddress=""
Describe "SEND" {
    $returnMsg = SEND "TO: test@hogehoge.com"
    It "Return 250 OK" {
        $returnMsg | Should -Be "250 OK"
    }
    It "`$toAddress is test@hogehoge.com" {
        $toAddress | Should -Be "test@hogehoge.com"
    }
}
