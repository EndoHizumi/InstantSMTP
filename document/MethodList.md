# InstantSMTP Method List

|コマンド名|引数|[型] 戻り値|挙動|
|:--:|:--:|:---|:--:|:--:|
HELO/EHLO|無し|[String] 250 OK|"250 OK”の文字列を返す。
MAIL|返信先アドレス|[String] 250 OK|返信先バッファ・送信先バッファ・メールデータバッファをクリアする。  返信先を保持する。
RCPT|送信先|[String] 250 OK|パラメータを転送先を保持する送信先バッファ（配列）に格納する。
DATA|無し|[String] 354 Ready|receivedMessageフラグをTrueにする。
VRFY|無し|[String] 250 OK|
EXPN|無し|[String] 250 OK|
QUIT|無し|無し|isQuitフラグをTrueにする。|
HELP|無し|[String[]] {マニュアル}|このドキュメントを返信する。
NOOP|無し|無し|無し
RSET|無し|[String] 250 OK|すべてのバッファをクリアする。
SEND|送信先メールアドレス|[String] 250 OK|パラメータを送信先バッファに加える
SOML|無し|[String]メッセージバッファの内容|ストリームに受信したメッセージを出力|
SAML|無し|[String]メッセージバッファの内容と出力ファイル名|ストリームと[Receive-Mail]フォルダーに受信したメッセージを出力  ファイル名:ReceiveMail_yyyyMMddhhmmssffff.eml|
TURN|無し|無し|実装なし