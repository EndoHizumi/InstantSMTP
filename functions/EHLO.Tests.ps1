$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
$clientDomain=""
Describe "EHLO" {
    $returnMsg=EHLO "abc.com:114514"
    It "Return 250 OK" {
        $returnMsg | Should -Be "250 OK"
    }
    It "`$clientDomain is abc.com:114514" {
        $clientDomain | Should -Be "abc.com:114514"
    }
    It "EHLO Args is Null" {
        EHLO| Should -Be "250 OK"
    }
}