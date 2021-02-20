codeunit 50101 "Process Website 1 Actions" implements iProcessWebSiteActions
{

    procedure ProcessActions(var WebIntAct: Record "Web Integration Action Log")
    begin
        Process(WebIntAct, false);
    end;

    procedure ProcessActions(TableIdBulkProcessing: Integer)
    var
        WebIntAct: Record "Web Integration Action Log";
    begin
        WebIntAct.Init();
        WebIntAct."Table Id" := TableIdBulkProcessing;
        Process(WebIntAct, true);
    end;

    local procedure Process(var WebIntAct: Record "Web Integration Action Log"; BulkProcess: Boolean)
    var
        WebIntegrationSetup: Record "Web Integration Setup";
        tmpWebIntActToMarkProcessed: Record "Web Integration Action Log" temporary;
        JsonRequestTxt: Text;
        JsonResponseTxt: Text;
        APILog: Record "Web Integration API Log";
        Endpoint: Text;
        Client: HttpClient;
        HttpResponse: HttpResponseMessage;
        ErrorText: Text;
        HttpContent: HttpContent;
    begin
        WebIntegrationSetup.Get();
        If NOT WebIntegrationSetup."Website 1 Integration Active" then
            Exit;

        WebIntegrationSetup.TestField("Website 1 API Base URL");
        WebIntegrationSetup.TestField("Website 1 Create Items");
        Case
            WebIntAct."Table Id" OF
            Database::Item:
                begin
                    Endpoint := WebIntegrationSetup."Website 1 API Base URL" + WebIntegrationSetup."Website 1 Create Items";
                    JsonRequestTxt := CreateJsonRequestForItems(WebIntAct, tmpWebIntActToMarkProcessed, BulkProcess);
                    IF JsonRequestTxt = '' then
                        exit; // nothing to do
                    HttpContent.WriteFrom(JsonRequestTxt);
                    if not IsSuccessfulRequest(Client.Post(Endpoint, HttpContent, HttpResponse), HttpResponse, ErrorText) then begin
                        APILog.InsertLog(Endpoint, 'POST', JsonRequestTxt, ErrorText);
                        IF GuiAllowed then
                            Error(ErrorText);
                        exit;
                    end;

                    HttpResponse.Content.ReadAs(JsonResponseTxt);
                    APILog.InsertLog(Endpoint, 'POST', JsonRequestTxt, JsonResponseTxt);
                    MarkActionLogEntriesProcessed(tmpWebIntActToMarkProcessed, APILog); //only if web request success!
                end;
        end;
    end;

    local procedure CreateJsonRequestForItems(var WebIntAct: Record "Web Integration Action Log"; var tempWebIntActToMarkProcessed: Record "Web Integration Action Log" temporary; BulkProcess: Boolean): Text
    var
        JObjectMain: JsonObject;
        JObjectItem: JsonObject;
        JArrayItems: JsonArray;
        JToken: JsonToken;
        WebIntAct_local: Record "Web Integration Action Log";
        RecRef: RecordRef;
        Item: Record Item;
        txt: Text;
    begin
        WebIntAct_local.Copy(WebIntAct);
        WebIntAct_local.SetRange(Processed, false);

        IF not BulkProcess then
            WebIntAct_local.SetRange(Id, WebIntAct_local.Id)
        Else begin
            WebIntAct_local.SetRange(WebIntAct_local."Table Id", WebIntAct_local."Table Id");
            WebIntAct_local.SetRange("For WebSite", WebIntAct_local."For WebSite"::"Website 1");
        end;

        IF WebIntAct_local.FindSet() then begin
            repeat
                RecRef := WebIntAct_local."Record ID".GetRecord();
                RecRef.SetTable(Item);
                IF Item.FIND('=') THEN begin
                    JObjectItem.Add('No', Item."No.");
                    JObjectItem.Add('ActionType', Format(WebIntAct_local."Action Type"));
                    JObjectItem.Add('No2', Item."No. 2");
                    JObjectItem.Add('Description', Item.Description);
                    JObjectItem.Add('UnitPrice', Item."Unit Price");
                    AddItemVariantsToJObjectItem(JObjectItem, Item);
                    AddItemTranslationToJObjectItem(JObjectItem, Item);
                    JArrayItems.Add(JObjectItem.Clone());
                    Clear(JObjectItem);
                end;
            Until WebIntAct_local.Next = 0;
            JObjectMain.Add('Items', JArrayItems);
            JObjectMain.WriteTo(txt);
        end;
        exit(txt);
    end;

    local procedure AddItemVariantsToJObjectItem(JsonObject: JsonObject; Item: Record Item)
    var
        ItemVariant: Record "Item Variant";
        JObjectItemVar: JsonObject;
        JArrItemVariants: JsonArray;
    begin
        ItemVariant.SetRange("Item No.", Item."No.");
        IF ItemVariant.FindSet() THEN begin
            repeat
                JObjectItemVar.Add('Code', ItemVariant.Code);
                JObjectItemVar.Add('Description', ItemVariant.Description);
                JArrItemVariants.Add(JObjectItemVar.Clone());
                Clear(JObjectItemVar);
            until ItemVariant.Next = 0;
            JsonObject.Add('ItemVariants', JArrItemVariants);
        end;
    end;

    local procedure AddItemTranslationToJObjectItem(JsonObject: JsonObject; Item: Record Item)
    var
        ItemTranslation: Record "Item Translation";
        JObjectItemTrans: JsonObject;
        JArrItemTranslations: JsonArray;
    begin
        ItemTranslation.SetRange("Item No.", Item."No.");
        IF ItemTranslation.FindSet() THEN begin
            repeat
                JObjectItemTrans.Add('LanguageCode', ItemTranslation."Language Code");
                JObjectItemTrans.Add('Description', ItemTranslation.Description);
                JObjectItemTrans.Add('VariantCode', ItemTranslation."Variant Code");
                JArrItemTranslations.Add(JObjectItemTrans.Clone());
                Clear(JArrItemTranslations);
            until ItemTranslation.Next = 0;
            JsonObject.Add('ItemTranslations', JArrItemTranslations);
        end;
    end;

    local procedure MarkActionLogEntriesProcessed(var tempWebIntActToMarkProcessed: Record "Web Integration Action Log" temporary; APILog: Record "Web Integration API Log")
    var
        WebActions: Record "Web Integration Action Log";
    begin
        IF tempWebIntActToMarkProcessed.FindSet() then
            repeat
                IF WebActions.Get(tempWebIntActToMarkProcessed) THEN begin
                    WebActions.Validate(Processed, TRue);
                    IF APILog."Entry No." > 0 then
                        WebActions."Web API Log Id" := APILog."Entry No.";
                    WebActions.Modify(true);
                end;
            until tempWebIntActToMarkProcessed.Next = 0;
    end;

    local procedure LogAPICall(Request: Text; Response: Text; HttpMethod: Code[10]; WebSetup: Record "Web Integration Setup")
    begin
        IF NOt WebSetup."Log API Requests" then
            exit;
    end;

    local procedure IsSuccessfulRequest(TransportOK: Boolean; Response: HttpResponseMessage; var ErrorTxt: Text): Boolean
    begin
        if TransportOK and Response.IsSuccessStatusCode() then
            exit(true);

        ErrorTxt := StrSubstNo('Something went wrong: %1', GetLastErrorText);
        exit(false);
    end;
}
