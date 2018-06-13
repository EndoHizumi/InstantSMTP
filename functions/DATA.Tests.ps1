$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
$isReceive=$false


Describe "DATA" {
    It "does something useful" {
         & DATA | Should -Be "354 Ready" 
        $isReceive | Should Be $true
    } 
}
