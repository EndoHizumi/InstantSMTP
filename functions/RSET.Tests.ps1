$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
$isQuit = $true
$isRecevie = $true
$toAddress = "foo@abc.com"
$fromAddress = "hige@hoge.com"
$msgBuffer = @("test","message")

Describe "RSET" {
    $returnMsg = RSET
    It "250 OK" {
       $returnMsg | Should -Be "250 OK"
    }
    It "`$isQuit is false"{
        $isQuit | Should -Be $false
    }
    It "`$isRecevie is false"{
        $isRecevie | Should -Be $false
    }
    It "`$toAddress is false"{
        $toAddress | Should -Be $false
    }
    It "`$fromAddress is false"{
        $fromAddress | Should -Be $false
    }
    It "`$msgBuffer is false"{
        $msgBuffer.Length | Should -Be 0
    }
}
