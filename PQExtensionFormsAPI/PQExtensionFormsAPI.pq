// This file contains your Data Connector logic
section PQExtensionFormsAPI;

[DataSource.Kind="PQExtensionFormsAPI", Publish="PQExtensionFormsAPI.Publish"]
shared PQExtensionFormsAPI.Contents = Value.ReplaceType(PQExtensionFormsAPIImpl, PQExtensionFormsAPIType);

// Data Source Kind description <https://github.com/microsoft/DataConnectors/blob/master/docs/m-extensions.md>
PQExtensionFormsAPI = [
    Authentication = [
        Aad = [
            AuthorizationUri = "https://login.microsoftonline.com/common/oauth2/authorize",
            Resource = "https://forms.office.com" // Azure AD resource value for your service - Guid or URL
        ]
    ],
    Label = Extension.LoadString("Forms API で Response 取得") // (optional Friendly display name for this extension in credential dialogs.         
    // , TestConnection    Gateway 経由でデータ更新する場合にはサポート必要
];

// Data Source UI publishing description
PQExtensionFormsAPI.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = PQExtensionFormsAPI.Icons,
    SourceTypeImage = PQExtensionFormsAPI.Icons
];

PQExtensionFormsAPI.Icons = [
    Icon16 = { Extension.Contents("PQExtensionFormsAPI16.png"), Extension.Contents("PQExtensionFormsAPI20.png"), Extension.Contents("PQExtensionFormsAPI24.png"), Extension.Contents("PQExtensionFormsAPI32.png") },
    Icon32 = { Extension.Contents("PQExtensionFormsAPI32.png"), Extension.Contents("PQExtensionFormsAPI40.png"), Extension.Contents("PQExtensionFormsAPI48.png"), Extension.Contents("PQExtensionFormsAPI64.png") }
];

formId2responses = (formId as text)  =>
let
    //   result = Json.Document(Web.Contents("https://forms.office.com/formapi/api/{tenantID}/users/{userID}/light/forms(" & formId & ")/responses")),
    result = Json.Document(Web.Contents("https://forms.office.com/formapi/api/forms/" & formId & "/responses")),
    responses = result[value]
in
    responses;

shared PQExtensionFormsAPI.Matches = (expression as text, optional original as text, optional indexBeginWith1 as number ) as text =>
let
    originalText = Text.Combine({original, ""}),
    expressionText = Text.Replace(expression, "\", "\\"),
    replaceResult =  Web.Page("<script>var originalText="&"'"&originalText&"'"&";var expression=new RegExp('"&expressionText&"','g');var result=originalText.match(expression);document.write(result);</script>")
        [Data]{0}[Children]{0}[Children],

    result = if (indexBeginWith1 = null) then {
        replaceResult{1}[Text]{0} as text 
    } else {
        let
            matches = Text.Split(replaceResult{1}[Text]{0}, ","),
            safeIndex = if (indexBeginWith1 <= 0 or indexBeginWith1 > List.Count(matches)) then 0 else indexBeginWith1 - 1 
        in 
            matches{safeIndex} as text
    }
in 
    result{0};

shared PQExtensionFormsAPI.Replace = (expression as text, optional original as text,  optional replacement as text) as text =>
let
    originalText = Text.Combine({original, ""}),
    expressionText = Text.Replace(expression, "\", "\\"),
    replaceText = Text.Combine({replacement, ""}),
    replaceResult =  Web.Page("<script>var originalText="&"'"&originalText&"'"&";var replacement="&"'"&replaceText&"'"&";var expression=new RegExp('"&expressionText&"','g');var result=originalText.replace(expression,replacement);document.write(result);</script>")
      [Data]{0}[Children]{0}[Children],

    result = if (List.Count(replaceResult) <= 1) then { 
      "" as text // 変換して何も残らない場合
    } else if (replaceResult{1}[Text]{0} = null) then {
      originalText   as text// 何も見つからない場合
    } else {
      replaceResult{1}[Text]{0} as text
    }
in 
    result{0};

PQExtensionFormsAPIType = type function (
    message as (type text meta [
        Documentation.FieldCaption = "Forms Url",
        Documentation.FieldDescription = "Text, 解析したい Forms の URL",
        Documentation.SampleValues = {"https://forms.office.com/Pages/DesignPage.aspx?route=Start#FormId=Ylunxf9LlkynIGYhzpl45X6btOKMGSpAhfdw3zJ9jQ1UNDdIVlZXN1JKSlNXVENEOU43RU9TSlJCNSQlQCN0PWcu"}
    ]))
    as list meta [
        Documentation.Name = "Forms API の解析",
        Documentation.LongDescription = "解析したい Forms API の URL をコピーして見ましょう。",
        Documentation.Examples = {[
            Description = "Returns error message with invalid Forms URL not including FormsId",
            Code = "PQExtensionFormsAPI.Contents(""invalid url"")",
            Result = "{ ""URL に ""FormId="" が含まれていませんでした。""}"
        ],[
            Description = "Returns valid responses!",
            Code = "PQExtensionFormsAPI.Contents(""https://forms.office.com/Pages/DesignPage.aspx?lang=ja&origin=OfficeDotCom&route=Start#FormId=Ylunxf9LlkynIGYhzpl45X6btOKMGSpAhfdw3zJ9jQ1UNDdIVlZXN1JKSlNXVENEOU43RU9TSlJCNSQlQCN0PWcu"")",
            Result = "{ [
                id = 1,
                startDate = ""2020-09-16T02:04:08.5515779Z"",
                submitDate = ""2020-09-16T02:04:08.5515779Z"",
                responder = ""responder@hoge.onmicrosoft.com"",
                responderName = ""responderName"",
                answers = ""[{""answer1"":""回答だよ"",""questionId"":""r9fb6fe72246141c1a635db431345b17b""}]"",
                releaseDate = ""0001-01-01T00:00:00Z"",
                quizResult = null,
                emailReceiptConsent = null,
                submitLanguage = null,
                msRewardsData = null,
                FormsProData = null
            ]}"
        ]}
    ];

PQExtensionFormsAPIImpl = (formsUrl as text) =>
    let
        _formId =Text.Replace(PQExtensionFormsAPI.Matches("FormId=[^&]+", formsUrl), "FormId=", ""),
//         _formIdLength = Text.Length(_formId),
        _message = if (_formId = null or Text.Length(_formId) < 80) then List.Generate(() => 1, each _ > 0, each _ - 1, each "URL に ""FormId="" が含まれていませんでした。") else formId2responses(_formId)
    in
        _message as list;