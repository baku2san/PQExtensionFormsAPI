# PQExtensionFormsAPI
Power Query Custom Connector to retreive Microsoft Forms responses by FormUrl

# 概要
Power BI で、Forms の分析が出来るように

# [Qiita での記事](https://qiita.com/baku2san/items/423a272074422d6a43c4)
使い方も画像付きであげてます。

# 使い方
1. Forms URL を渡す。<br>URL 例）https://forms.office.com/Pages/DesignPage.aspx?lang=ja-JP&origin=OfficeDotCom&route=Start#FormId=5yeNf3C-7UuD1Ze-mrfnESHR_FsoAN5IhfS8_RTMEAVUQzNIWUM5MlIwUzFCMVRNWEhGVzAxRFI0TC4u
1. responses が取得出来る
1. answers で回答一覧が。

# Forms API 

[Microsoft Forms API 現時点でのまとめ](https://qiita.com/baku2san/items/47c8ad906e01d7e5d5b9) 参照のこと

# Data Connector 

[Sample とか詳細はここ](https://github.com/microsoft/DataConnectors)

# authentication

[認証の処理](https://docs.microsoft.com/ja-jp/power-query/handlingauthentication#azure-active-directory-authentication) を元に実装

## [OAuth2](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-auth-code-flow)


