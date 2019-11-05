codeunit 50001 "Update Distances"
{
    trigger OnRun()
    var
        APIKey: Text;
        DistanceCalcSetupLine: Record "Distance Calculator Setup Line";
        Url: Text;
    begin
        DistanceCalcSetupLine.Get('GOOGLE MAPS');
        APIKey := DistanceCalcSetupLine."API Key";
        Url := DistanceCalcSetupLine."API Base URL" +
            'xml?origins=57,+Ion+Heliade Radulescu,+Campina,+Prahova,+Romania&destinations=11,+Episcopul Vulcan,+Bucharest,+Bucharest,+Romania&mode=driving&key=' + APIKey;

        ImportDistance(Url, DistanceCalcSetupLine."Data Exch. Def. Code");

    end;

    procedure ImportDistance(Url: Text; DataExchangeDefCode: Code[20]);
    var
        HttpClient: HttpClient;
        Response: HttpResponseMessage;
        ResponseString: Text;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        inStr: InStream;
        DataExchange: Record "Data Exch.";
        XmlDoc: XmlDocument;
        GetJsonStructure: Codeunit "Get Json Structure";
        DataExchangeDef: Record "Data Exch. Def";
    begin
        HttpClient.Get(Url, Response);

        If not Response.IsSuccessStatusCode() then
            Error(StrSubstNo('Status code: %1\' +
                'Description: %2',
                Response.HttpStatusCode(),
                Response.ReasonPhrase()));

        Response.Content.ReadAs(ResponseString);

        XmlDocument.ReadFrom(ResponseString, XmlDoc);
        TempBlob.CreateOutStream(OutStr);
        XmlDoc.WriteTo(OutStr);

        TempBlob.CreateInStream(inStr);

        //create data exchange
        DataExchangeDef.Get(DataExchangeDefCode);
        DataExchange.InsertRec('GoogleMapsDistanceMatrix', inStr, DataExchangeDef.Code);
        CODEUNIT.RUN(DataExchangeDef."Reading/Writing Codeunit", DataExchange);

        //create distance calcutation records using field mapping

    end;

}