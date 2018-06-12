# InstantSMTP

[Click here for English Version](Readme.md)

## 概要
InstantSMTP は、ユニットテスト向け組み込み式SMTPサーバーです。

## 使い方

```PowerShell

``` 

## サンプルコード

```PowerShell

# sample.ps1
."instantSMTP.ps1"
$message = Get-MailMessage -i 127.0.0.1 -p 25
$diff = (Compare-Object $message (gc expectMessage.eml)
if ($diff.length -ne 0){
    Write-Error "Fail."
}

```