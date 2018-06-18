function RCPT ($Arg) {
    Write-Debug $Arg
    $script:toAddress = $Arg
    return "250 OK"
}