$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
$clientDomain=""
Describe "HELO" {
    $returnMsg=HELO "abc.com:114514"
    It "Return 250 OK" {
        $returnMsg | Should -Be "250 OK"
    }
    It "`$clientDomain is abc.com:114514" {
        $clientDomain | Should -Be "abc.com:114514"
    }
    It "HELO Args is Null" {
        HELO| Should -Be "250 OK"
    }
}