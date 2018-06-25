# SMTP_S.ps1
$clientDomain = ""
$isQuit = $false
$isReceiveState = $false
$toAddress = ""
$fromAddress = ""
$msgBuffer = @()

function responce ([string]$data, $stream) {
    $Sendbytes = [System.Text.Encoding]::UTF8.GetBytes($data + " `r`n")
    $stream.Write($Sendbytes, 0, $Sendbytes.Length) | Out-Null
    Write-Verbose "SERVER ==> CLIENT : ${data}"
    if ($DebugPreference -eq "continue") {
        $temp = ($Sendbytes -join " ")
        Write-Debug "SendBytes:$temp"
    }
}

function receive ($stream, $readLength = 1024) {
    [String]$receivetext = ""
    Write-Verbose "begin Data read"
    [byte[]]$Readbytes = New-Object byte[] $readLength
    $result = $stream.Read($Readbytes, 0, $readLength)
    [byte[]] $removeZeroArray = New-Object byte[] $result
    [System.Array]::Copy($Readbytes, 0, $removeZeroArray, 0, $result)
    Write-Verbose "Read ${result}Byte"
    if ($DebugPreference -eq "continue") {
        $temp = ($removeZeroArray -join " ")
        Write-Debug "ReadValidBytes(${result}Byte):$temp"
    }
    $receivetext += [System.Text.Encoding]::UTF8.GetString($removeZeroArray)
    $Readbytes = $null
    Write-Verbose "CLIENT ==> SERVER : $receivetext"
    if ($isReceiveState) {
        $receivetext
    }
    else {
        , ($receivetext.Replace("`r`n","")).Split(" ")
    }
    
}
function  Show-Status () {
    Write-Debug "Show-Status Start >> `r`n"
    Write-Debug "`$clientDomain:$clientDomain"
    Write-Debug "`$isReceiveState:$isReceiveState"
    Write-Debug "`$isQuit:$isQuit"
    Write-Debug "`$toAddress:$toAddress"
    Write-Debug "`$fromAddress:$fromAddress"
    Write-Debug "`$msgBuffer:$msgBuffer"
    Write-Debug ">> Show-Status End`r`n"
}

#制御用変数の初期化
function  Initialize-Status () {
    $script:sequence = 0
    $script:clientDomain = ""
    $script:isReceiveState = $script:false
    $script:isQuit = $script:false
    $script:toAddress = ""
    $script:fromAddress = ""
    $script:msgBuffer = ""
}


function Get-MailMessage([int]$port = 25, [string]$IPAdress = "127.0.0.1", [switch]$isOutputFile = $true) {
    $tracelogPath = "${PSScriptRoot}/../log/traceLog" + (get-date -Format "yyyyMMddhhmmssffff") + [String]::format( "{0:0000}", ($sequence += 1)) + ".txt"
    Start-Transcript -Path $tracelogPath |  Write-Verbose
    Initialize-Status
    Write-Verbose "Initialized status buffer"
    Show-Status

    $listener = new-object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Parse($IPAdress), $port)
    $listener.start()
    Write-Verbose "Waiting for a connection on ${IPAdress}:${port}..."
    $client = $listener.AcceptTcpClient() 
    Write-Verbose "Connected from $($client.Client.RemoteEndPoint)"
    $stream = $client.GetStream()

    try {
        responce -data "220 ready" -stream $stream 
        while (!$isQuit) {
            Show-Status
            if ($isReceiveState) {
                $receivetext = (receive $stream $true 2097152)
                $script:msgBuffer += $receivetext
                $sendText = "250 OK Receive Message"    
                if ($receivetext.EndsWith(".`r`n")) {
                    $isReceiveState = $false
                    Write-Verbose "Message End"
                }
                else {
                    $isReceiveState = $true
                }
            }
            else {
                $receivetext = (receive $stream)
                $command = ($receivetext[0].Substring(0, 4))
                Write-Verbose "$PSScriptRoot\${command}.ps1"
                if ($receivetext.count -eq 0) {
                    responce -data $null -stream $stream
                    continue
                }
                if ([System.IO.File]::Exists("$PSScriptRoot\${command}.ps1")) {
                    Throw "UserException"
                    Write-Verbose "OK Invoke Command ${command}"
                    $sendText = if($receivetext.count -eq 1){
                        (& $command)
                    }else{
                        (& $command $receivetext[1])
                    }
                }
                else {
                    $sendText = "502 Command not implemented"
                }     
            }
            responce -data $sendText -stream $stream
            $receivetext = ""
        }
    }
    catch {
        responce -data "451 Innternal Error" -stream $stream
        Write-Verbose $global:error[0] 
        throw $global:error[0] 
    }
    finally {
        $client.Close()
        $listener.Stop()
        Write-Verbose "Connection closed."
        Write-Output  $script:msgBuffer
        if($isOutputFile){
            $filename = "ReceiveMessage_" + (get-date -Format "yyyyMMddhhmmssffff") + [String]::format( "{0:0000}", ($sequence += 1)) + ".eml"
            Set-Content -Path "${PSScriptRoot}/../mailBox/${filename}" -Value $script:msgBuffer -Encoding utf8
        }
        RSET |Out-Null
        Stop-Transcript | Write-Verbose
    }
}

