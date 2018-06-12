# SMTP_S.ps1
$isQuit = $false
$isRecevie = $false
function responce ([string]$data, $stream) {
    $Sendbytes = [System.Text.Encoding]::UTF8.GetBytes($data + " `r`n")
    $stream.Write($Sendbytes, 0, $Sendbytes.Length)
    write-host $Sendbytes
    write-host "SERVER ==> CLIENT : ${data}"
}

function receive ($stream) {
    [byte[]]$Readbytes = 0..255| % {0}
    $stream.Read($Readbytes, 0, $Readbytes.Length)
    [String] $receivetext = [System.Text.Encoding]::UTF8.GetString($Readbytes)
    write-host "CLIENT ==> SERVER : $receivetext"
    write-host $Readbytes
    , ($receivetext.trim()).Split(" ")
}

function Get-MailMessage([int]$port = 25, [string]$IPAdress = "127.0.0.1", [switch]$Echo = $false) {
    $listener = new-object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Parse($IPAdress), $port)
    $listener.start()
    $msgBuffer = @()
    write-host "Waiting for a connection on ${IPAdress}:${port}..."
    $client = $listener.AcceptTcpClient() 
    write-host "Connected from $($client.Client.RemoteEndPoint)"
    $stream = $client.GetStream()
    try {
        responce -data "220 ready" -stream $stream 
        while (!$isQuit) {
            $receivetext = (receive $stream)
            $command = ($receivetext[1].Substring(0, 4)).Trim()
            $command.Length
            if ($command.Length -ne 0) {
                Write-Host "$PSScriptRoot\${command}.ps1"
                if (Test-Path  "$PSScriptRoot\${command}.ps1") {
                    $sendText = (& $command $receivetext[2])
                }
                else {
                    if ($isRecevie) {
                        if ($receivetext -ne ".") {
                            $msgBuffer += $receivetext
                            $sendText = "250 OK"    
                        }
                        else {
                            $isRecevie = $false
                        }
                    }
                    else {
                        $sendText = "502 Command Not Found"
                    }
                }
           
            }
            else {
                $sendText = "502 Command Not Found"
            }
            responce -data $sendText -stream $stream
            Start-Sleep -Seconds 1
        }
    }
    finally {
        $client.Close()
        $listener.Stop()
        write-host "Connection closed."
        Write-Output $msgBuffer
    }
}

