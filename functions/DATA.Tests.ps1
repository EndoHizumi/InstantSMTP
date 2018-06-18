$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
$isReceive=$false

Describe "DATA" {
    $returnMsg = & DATA
    It "Return 354" {
        $returnMsg | Should -Be "354 Ready" 
    } 
    It "`$isReceive is true"{
        $isReceive | Should Be $true
    }
}
