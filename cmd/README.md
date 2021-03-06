Mailbox CMD [![GoDoc](https://godoc.org/github.com/toomore/mailbox/cmd?status.svg)](https://godoc.org/github.com/toomore/mailbox/cmd)
============

四個主要的命令來運作 **Mailbox**，`mailbox campaign`, `mailbox user`,
`mailbox sender`, `mailbox server`

也提供將程式編譯後再放入 `alpine`。

CMD
----

### `mailbox campaign`
建立 `campaign`，包含產生該 `campaign` 的亂數種子。

### `mailbox user`
匯入訂閱者的資訊。

### `mailbox sender`
發送電子報，以 **HTML** 格式發送。

### `mailbox server`
接收開信訊息。

**Docs:** [docs/mailbox](docs/mailbox.md)

Docker
-------

### `toomore/mailbox:cmd`
只將編譯過的 `cmd` 程式放入。

    sh ./build-min.sh;

**Required:** `toomore/mailbox:base`, run `sh ./build-base.sh` first.

... and Run

    docker run -it --rm toomore/mailbox:cmd [sh or mailbox's cmd]
