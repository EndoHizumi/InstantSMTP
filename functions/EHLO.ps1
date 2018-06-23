function EHLO ($arg) {
    $script:clientDomain=$arg
    return "250 OK"
}