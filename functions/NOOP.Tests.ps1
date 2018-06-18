$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "NOOP" {
    It "Return 250 OK" {
        NOOP | Should -Be "250 OK"
    }
}
