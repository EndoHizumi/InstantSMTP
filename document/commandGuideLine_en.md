# command coding GuideLine

日本語は[こちら][1]

## OverView

instantSMTP can expand and define commands.
This document describes its coding rules.

## Specifications

When **InstantSMTP** receives a message, it calls a function that matches the command.
If the call fails, send a reply code: **502** to the client.

[1]:commandGuideLine_ja.md