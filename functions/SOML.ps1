function SOML () {
    $buffer=""
    foreach($item in $script:msgBuffer){
        $buffer += $item + "`r`n"
    }
    return $buffer
}