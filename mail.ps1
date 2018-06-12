# Mail.ps1

# 送信先メールアドレス
$to = "you@sukekeke.com"
 
# 送信元メールアドレス
$from = "me@sukekeke.com"

# メール件名
$subject = "Powershell Message"

# 本文
$body += "Mail to Server From Powershell`n"
$body += "Hello World !!"

# SMTPサーバのIPアドレス
$smtp = "127.0.0.1"


# メール送信
Send-MailMessage -To $to -From $from -SmtpServer $smtp -Subject $subject -Body $body -Encoding UTF8