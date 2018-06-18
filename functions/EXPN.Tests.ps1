﻿$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "EXPN" {
    It "Return 502" {
        EXPN | Should -Be "502 Command not implemented"
    }
}
