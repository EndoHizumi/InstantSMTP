$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "HELO" {
    It "does something useful" {
        Com-HELO | Should -Be "250 OK"
    }
}
