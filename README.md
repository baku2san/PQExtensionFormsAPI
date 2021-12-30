# PQExtensionFormsAPI
Power Query Custom Connector to retreive Microsoft Forms responses by FormUrl

# purpopse
To analyze Microsoft Forms Responses by Power BI

# Qiita in Japanese  
[release Microsoft Forms custom data connector for Power BI](https://qiita.com/baku2san/items/423a272074422d6a43c4)

# how to use
1. paste Forms URL in the <FormsUrl><br>ex.）https://forms.office.com/Pages/DesignPage.aspx?lang=ja-JP&origin=OfficeDotCom&route=Start#FormId=5yeNf3C-7UuD1Ze-mrfnESHR_FsoAN5IhfS8_RTMEAVUQzNIWUM5MlIwUzFCMVRNWEhGVzAxRFI0TC4u<br>![Connecting](../Documents/Connecting.png)
1. connect, then retreive responses including answers, you can convert to table then expland it to get answers column.<br>![RetreiveSample](../Documents/RetreiveSample.png)

# about Forms API 
[Microsoft Forms API in my view](https://qiita.com/baku2san/items/47c8ad906e01d7e5d5b9)

# Data Connector 
[details and samples by Microsoft](https://github.com/microsoft/DataConnectors)

# authentication

[aad authentication](https://docs.microsoft.com/ja-jp/power-query/handlingauthentication#azure-active-directory-authentication) 

## [OAuth2](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-auth-code-flow)


