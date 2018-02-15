;;; freee.el --- freee on Emacs                         -*- lexical-binding: t; -*-

;; Copyright (C) 2018  tamura shingo

;; Author: tamura shingo <tamura.shingo@gmail.co.jp>
;; URL: https://github.com/tamurashingo/freee.el
;; Version: 0.0.1
;; Package-Requires: ((cl-lib) (json) (oauth2))
;; Keywords: extensions

;; MIT License

;; Permission is hereby granted, free of charge, to any person obtaining a copy of
;; this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be included in
;; all copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
;; THE SOFTWARE.


;;; Commentary:


;;; Code:
(require 'cl-lib)
(require 'json)
(require 'oauth2)


;; ----------------------------------------
;; Constants
;; ----------------------------------------
(defconst freee:api-auth "https://secure.freee.co.jp/oauth/authorize")
(defconst freee:api-token "https://api.freee.co.jp/oauth/token")

(defconst freee:api-endpoint "https://api.freee.co.jp")
(defconst freee:api-companies "/api/1/companies.json")
(defconst freee:api-account-items "/api/1/account_items.json")
(defconst freee:api-partners "/api/1/partners.json")
(defconst freee:api-items "/api/1/items.json")


;; ----------------------------------------
;; External variables
;; ----------------------------------------
(defvar freee:client-id nil
  "freee APIで使用するAppID")
(defvar freee:client-secret nil
  "freee APIで使用するSecret")
(defvar freee:company-id nil
  "操作対象のcompany id")


;; ----------------------------------------
;; Local variables
;; ----------------------------------------
(defvar freee:token nil
  "freee API用トークン")


;; ----------------------------------------
;; private functions
;; ----------------------------------------
(defun freee:octet-to-utf8 ($str)
  "\344\272\213 形式の文字列をutf-8でデコードする"
  (with-temp-buffer
    (insert $str)
    (decode-coding-region (point-min) (point-max) 'utf-8)
    (buffer-string)))

(defun freee:get-token ()
  "キャッシュしてあるAPI用トークンを返す。
キャッシュがない場合はストアしてあるトークンを返す。
ストアしてあるトークンがない場合はブラウザを起動し、トークンの入力を待つ"
  (when (null freee:token)
    (setq freee:token
          (oauth2-auth-and-store freee:api-auth
                                 freee:api-token
                                 nil
                                 freee:client-id
                                 freee:client-secret)))
  freee:token)

;; ----------------------------------------
;; Private api functions
;; ----------------------------------------
(defun freee:api-call-fetch (api-url)
  "GET系APIを実行するためのベース関数"
  (with-current-buffer
      (oauth2-url-retrieve-synchronously (freee:get-token)
                                         api-url)
    (goto-char url-http-end-of-headers)
    (let* ((buf (buffer-substring-no-properties (point) (point-max)))
           (str (freee:octet-to-utf8 buf)))
      (json-read-from-string str))))

(defun freee:api-get-companies ()
  "companies一覧を取得する"
  (freee:api-call-fetch (concat freee:api-endpoint freee:api-companies)))

(defun freee:api-get-account-items ()
  "勘定科目を取得する"
  (freee:api-call-fetch (concat freee:api-endpoint freee:api-account-items "?company_id=" freee:company-id)))

(defun freee:api-get-partners ()
  "取引先一覧を取得する"
  (freee:api-call-fetch (concat freee:api-endpoint freee:api-partners "?company_id=" freee:company-id)))



;; ----------------------------------------
;; External functions
;; ----------------------------------------
(defun freee:initialize ()
  "freee.elの初期化を行う。
- tokenの取得
- company id一覧を表示"
  (let* ((token (freee:get-token))
         (companies (cdr (assoc 'companies
                                (freee:api-get-companies)))))
    (seq-doseq (company companies)
      (let ((id (cdr (assoc 'id company)))
            (display_name (cdr (assoc 'display_name company))))
        (print (format "company id:%s\t事業所名:%s" id display_name))))))


(defun freee:transaction ()
  "取引を登録する"
  )



(provide 'freee)


;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:
;;; freee.el ends here
