$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
$fromAddress=""
Describe "MAIL" {
    It "Return 250 OK" {
        MAIL "FROM from@abc.com" | Should -Be "250 OK"
    }
    It "`$fromAddress is from@abc.com" {
        MAIL "FROM from@abc.com"  
       $fromAddress | Should -Be "from@abc.com"
    }
}
