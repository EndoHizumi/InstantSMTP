function SEND ($ToArgs) {
    $to= ($ToArgs.split(" "))[1]
    Write-Debug ($ToArgs.split(" ")).length
    Write-Debug $ToArgs
    $script:toAddress = $to
    return "250 OK"
}