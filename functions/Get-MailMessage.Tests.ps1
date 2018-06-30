
function get-TestMessage(){
$us = New-Object system.globalization.cultureinfo("en-US")
[String] $utcTime = (Get-Date).ToString("d MMM yyyy HH:mm:ss",$us)
[String] $utcOffset =  (Get-Date).ToString("zzz").Replace(":","")
@"
MIME-Version: 1.0
From: foo@example.com
To: hoge@example.com
Date: ${utcTime} ${utcOffset}
Subject: test Message
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

hello InstanSMTP.


.

"@
}
Describe "get-mailmessage" {
    It "Return TestMessage" {
        $result = Start-Job -ScriptBlock{import-module C:\Users\sh.kikuchi\Documents\GitHub\InstantSMTP\InstantSMTP.psm1;get-mailmessage;}
        Send-MailMessage -To "hoge@example.com" -From "foo@example.com" -SmtpServer "127.0.0.1" -Subject "test Message" -Body "hello InstanSMTP." -Encoding UTF8   
        $expect = get-TestMessage
        while ($result.State -ne "Completed"){
            Start-Sleep -Milliseconds 1
        }
        $actual = Receive-Job $result.Id
        (Compare-Object $actual $expect).count | Should -be 0
    }
}
