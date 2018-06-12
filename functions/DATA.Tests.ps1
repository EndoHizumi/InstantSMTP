$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'


Describe "DATA" {
    It "does something useful" {
        $isReceive=$false
        . "$here\$sut"
         & DATA | Should -Be "354 Ready" 
    } 
}
