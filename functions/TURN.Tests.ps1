$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "TURN" {
    It "Return 502" {
        TURN | Should -Be "502 Command not implemented"
    }
}
