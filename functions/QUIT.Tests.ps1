$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
$isQuit=$false
Describe "QUIT" {
    $returnMsg = QUIT
    It "Return Null" {
        $returnMsg | Should -Be $null
    }
    It "`$isQuit is false" {
        $isQuit | Should -Be $true
    }
}
