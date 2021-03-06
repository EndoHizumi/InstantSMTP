# InstantSMTP

[Click here for English Version](Readme.md)

## 概要
InstantSMTP は、ユニットテスト向け組み込み式SMTPサーバーです。
![demo](/document/demo.gif)

## インストール方法

```
git clone InstantSMTP

```

## 使い方

事前に、PowerShellスクリプトの実行を許可してください。
```PowerShell
import-module .\InstantSMTP.psm1
get-mailmessage
``` 

## サンプルコード

```PowerShell:Get-MailMessage.Tests.ps1

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
        $result = Start-Job -ScriptBlock{import-module .\InstantSMTP.psm1;get-mailmessage;}
        Send-MailMessage -To "hoge@example.com" -From "foo@example.com" -SmtpServer "127.0.0.1" -Subject "test Message" -Body "hello InstanSMTP." -Encoding UTF8   
        $expect = get-TestMessage
        while ($result.State -eq "Running"){
            Start-Sleep -Milliseconds 1
        }
        $actual = Receive-Job $result.Id
        (Compare-Object $actual $expect).count | Should -be 0
    }
}


```