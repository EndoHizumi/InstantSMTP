function SAML () {
    $data = SOML
    $path = "ReceiveMail_"+(DATE -Format "yyyyMMddhhmmssfff")+".eml"
    Set-Content -path $path -Value $data
    $path
    return $data
}