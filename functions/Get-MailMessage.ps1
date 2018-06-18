# SMTP_S.ps1
$clientDomain = ""
$isQuit = $false
$isReceive = $false
$toAddress = ""
$fromAddress = ""
$msgBuffer = @()

function responce ([string]$data, $stream) {
    $Sendbytes = [System.Text.Encoding]::UTF8.GetBytes($data + " `r`n")
    $stream.Write($Sendbytes, 0, $Sendbytes.Length) | Out-Null
    #Write-host $Sendbytes
    write-host -ForegroundColor Yellow "SERVER ==> CLIENT : ${data}"
    $Sendbytes = $null
}

function receive ($stream,$readBuffer=1024){
    [byte[]]$Readbytes = 0..$readBuffer| % {0}
    $stream.Read($Readbytes, 0, $Readbytes.Length)
    [String] $receivetext = [System.Text.Encoding]::UTF8.GetString($Readbytes)
    write-host -ForegroundColor Yellow "CLIENT ==> SERVER : $receivetext"
    $Readbytes = $null
    # Write-host $Readbytes
    , $receivetext.Split(" ")
}

function  Show-Status () {
    write-debug "Show-Status Start >> `r`n"
    write-debug "`$clientDomain:$clientDomain"
    write-debug "`$isReceive:$isReceive"
    write-debug "`$isQuit:$isQuit"
    write-debug "`$toAddress:$toAddress"
    write-debug "`$fromAddress:$fromAddress"
    write-debug "`$msgBuffer:$msgBuffer"
    write-debug ">> Show-Status End`r`n"
}

#制御用変数の初期化
function  Init-Status () {
    $script:clientDomain = ""
    $script:isReceive = $script:false
    $script:isQuit = $script:false
    $script:toAddress = ""
    $script:fromAddress = ""
    $script:msgBuffer = ""
}


function Get-MailMessage([int]$port = 25, [string]$IPAdress = "127.0.0.1", [switch]$Echo = $false) {
    Show-Status
    Init-Status
    Write-Host "Initialized status buffer"
    Show-Status

    $listener = new-object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Parse($IPAdress), $port)
    $listener.start()
    write-host "Waiting for a connection on ${IPAdress}:${port}..."
    $client = $listener.AcceptTcpClient() 
    write-host "Connected from $($client.Client.RemoteEndPoint)"
    $stream = $client.GetStream()

    try {
        responce -data "220 ready" -stream $stream 
        while (!$isQuit) {
            Show-Status
            if ($isReceive) {
                $receivetext = (receive $stream 2097152)
                if (!$receivetext.EndsWith(".")) {
                    $script:msgBuffer += $receivetext
                    $sendText = "250 OK Receive Message"    
                }
                else {
                    $isReceive = $false
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
                    Write-Debug "OK Invoke Command ${command}"
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
        write-host -ForegroundColor red $error
        responce -data "451 Innternal Error" -stream $stream
    }
    finally {
        RSET |Out-Null
        $client.Close()
        $listener.Stop()
        write-host "Connection closed."
        Write-Output $msgBuffer
    }
}

