function RSET () {
    $script:isQuit = $false
    $script:isRecevie = $false
    $script:toAddress = ""
    $script:fromAddress = ""
    $script:msgBuffer = @()
    return "250 OK"
}