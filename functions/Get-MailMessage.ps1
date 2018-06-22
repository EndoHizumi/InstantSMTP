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
     if ($DebugPreference -eq "continue"){ $temp = ($Sendbytes -join " ")}
     Write-Debug "SendBytes:$temp"
}

function receive ($stream, $isDataReceive = $false) {
    [byte[]]$Readbytes = New-Object byte[] 2097152
    [String]$receivetext = ""
    while ([String]$receivetext.EndsWith("`r`n") -eq $false) {
        Write-Debug "begin Data read"
        $result=$stream.Read($Readbytes, 0, 102400)
        Write-Debug "Read ${result}Byte"
        $Readbytes = filterZeroByte $Readbytes
        if ($DebugPreference -eq "continue"){$temp = ($Readbytes -join " ")}
        Write-Debug "ReadValidBytes(${result}Byte):$temp"
        $receivetext += [System.Text.Encoding]::UTF8.GetString($Readbytes)
    }
    Write-Verbose "CLIENT ==> SERVER : $receivetext"
    if ($isDataReceive) {
        $receivetext
    }
    else {
        , $receivetext.Split(" ")
    }
}

function filterZeroByte ([Array] $data) {
    foreach ($item in $data) {
        if ($item -eq 0) {
            break
        }
        $count++
    }
    [byte[]] $removeZeroArray = New-Object byte[] $count
    [System.Array]::Copy($data,0,$removeZeroArray,0,$count)
    , $removeZeroArray
}

function  Show-Status () {
    write-debug "Show-Status Start >> `r`n"
    write-debug "`$clientDomain:$clientDomain"
    write-debug "`$isReceiveState:$isReceiveState"
    write-debug "`$isQuit:$isQuit"
    write-debug "`$toAddress:$toAddress"
    write-debug "`$fromAddress:$fromAddress"
    write-debug "`$msgBuffer:$msgBuffer"
    write-debug ">> Show-Status End`r`n"
}

#制御用変数の初期匁E
function  Initialize-Status () {
    $script:clientDomain = ""
    $script:isReceiveState = $script:false
    $script:isQuit = $script:false
    $script:toAddress = ""
    $script:fromAddress = ""
    $script:msgBuffer = ""
}


function Get-MailMessage([int]$port = 25, [string]$IPAdress = "127.0.0.1", [switch]$Echo = $false) {
    Initialize-Status
    Write-Debug "Initialized status buffer"
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
                $receivetext = (receive $stream $true)
                
                $script:msgBuffer += $receivetext
                $sendText = "250 OK Receive Message"    
                if ($receivetext[$receivetext.count - 1].EndsWith(".`r`n")) {
                    $isReceiveState = $false
                    Write-Debug "Message End"
                }
                else {
                    $isReceiveState = $true
                }
            }
            else {
                $receivetext = (receive $stream)
                $command = ($receivetext[0].Substring(0, 4))
                Write-Debug "$PSScriptRoot\${command}.ps1"
                if ($receivetext.count -eq 0) {
                    responce -data $null -stream $stream
                    continue
                }
                if ([System.IO.File]::Exists("$PSScriptRoot\${command}.ps1")) {
                    Write-Verbose "OK Invoke Command ${command}"
                    $sendText = (& $command $receivetext[1])
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
        $error
        Show-Status
        responce -data "451 Innternal Error" -stream $stream
    }
    finally {
        $client.Close()
        $listener.Stop()
        Write-Verbose "Connection closed."
        Write-Output  $script:msgBuffer
        RSET |Out-Null
    }
}

