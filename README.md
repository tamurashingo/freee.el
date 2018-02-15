# freee.el
Emacsからfreeeをコネコネする

## require

- cl-lib
- json
- oauth2

oauth2で取得したトークンなどを保存するためGPGの設定が必要になります。


## 使い方

### 使用するcompany idが不明な場合

以下の2つの値を設定します。

```elisp
(setq freee:client-id "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
(setq freee:client-secret "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
```

company idの一覧を取得します。
`*scratch*`などから以下の関数を実行してください。

```elisp
(freee:initialize)
```

初回の場合はブラウザが開いてfreeeのログインが促されます。
アプリ連携の開始を許可して、表示された認証コードを入力してください。


そうすると、事業所名とそのcompany idの一覧が表示されます。

### 使用するcompany idがわかっている場合

以下の3つの値を設定します。

```elisp
(setq freee:client-id "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
(setq freee:client-secret "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
(setq freee:company-id "xxxx")
```


