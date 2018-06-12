# SMTP_S.ps1

param([int]$port = 25, [string]$IPAdress = "127.0.0.1", [switch]$Echo = $false) 
$ErrorActionPreference = "stop"
$isQuit= $false
$listener = new-object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Parse($IPAdress), $port)
$listener.start()

write-host "Waiting for a connection on port $port..."
$client = $listener.AcceptTcpClient() 
write-host "Connected from $($client.Client.RemoteEndPoint)"
    
$stream = $client.GetStream()
    
Start-Sleep -m 500
    
# 送信 220
$text = "220 localhost testshell ready `r`n"
$Sendbytes = [System.Text.Encoding]::UTF8.GetBytes($text)
$stream.Write($Sendbytes, 0, $Sendbytes.Length)
write-host "SERVER ==> CLIENT : SEND 220"

try {
    
    while (!$isQuit) {
        # 受信 EHLO or HELO
        [byte[]]$Readbytes = 0..255| % {0}
        $stream.Read($Readbytes, 0, $Readbytes.Length)
        $receivetext = [System.Text.Encoding]::UTF8.GetString($Readbytes)
        write-host "CLIENT ==> SERVER : $receivetext"

        # 送信 250 色、E
        $sendtext = "250 OK`r`n"
        $Sendbytes = [System.Text.Encoding]::UTF8.GetBytes($sendtext)
        $stream.Write($Sendbytes, 0, $Sendbytes.Length)
        write-host "SERVER ==> CLIENT : $sendtext"

        if ($receivetext.Contains("QUIT")) {
            $isQuit = $true
        }

        Start-Sleep -m 1
    }
}
finally {
    $client.Close()
    $listener.Stop()
    
    write-host "Connection closed."
}