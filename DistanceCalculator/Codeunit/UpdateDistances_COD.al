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
        rootNode: XmlNode;
        NavDataElement: XmlElement;
        newElement: XmlElement;
        T: Text;
    begin
        HttpClient.Get(Url, Response);

        If not Response.IsSuccessStatusCode() then
            Error(StrSubstNo('Status code: %1\' +
                'Description: %2',
                Response.HttpStatusCode(),
                Response.ReasonPhrase()));

        Response.Content.ReadAs(ResponseString);

        XmlDocument.ReadFrom(ResponseString, XmlDoc);

        //add to xml extra needed info: Customer No, Address Code, Location Code
        XmlDoc.SelectSingleNode('//*', rootNode);

        NavDataElement := XmlElement.Create('NavData');
        newElement := XmlElement.Create('CustomerNo');
        newElement.Add('10000');
        NavDataElement.Add(newElement);
        newElement := XmlElement.Create('AddressCode');
        newElement.Add('Default');
        NavDataElement.Add(newElement);
        newElement := XmlElement.Create('LocationCode');
        newElement.Add('BLUE');
        NavDataElement.Add(newElement);
        rootNode.AsXmlElement().AddFirst(NavDataElement);

        TempBlob.CreateOutStream(OutStr);
        XmlDoc.WriteTo(OutStr);

        TempBlob.CreateInStream(inStr);
        //inStr.Read(T);
        //Message(T);

        //create data exchange
        DataExchangeDef.Get(DataExchangeDefCode);
        DataExchange.InsertRec('GoogleMapsDistanceMatrix', inStr, DataExchangeDef.Code);
        CODEUNIT.RUN(DataExchangeDef."Reading/Writing Codeunit", DataExchange);

        //create distance calcutation records using field mapping
        DataExchangeDef.ProcessDataExchange(DataExchange);

    end;

}