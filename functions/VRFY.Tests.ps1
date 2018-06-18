$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "VRFY" {
    It "Return 502" {
        VRFY | Should -Be "502 Command not implemented"
    }
}
