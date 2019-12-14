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
            'xml?origins=5,+Bulevardul+Unirii,+Bucharest,+Bucharest,+Romania&destinations=1,+Stadionului,+Brasov,+Romania,+Romania&mode=driving&key=' + APIKey;

        ImportDistance(Url, DistanceCalcSetupLine, '30000', 'Default', 'GREEN');

    end;

    procedure ImportDistance(Url: Text; DistanceCalcSetupLine: Record "Distance Calculator Setup Line"; CustomerNo: Code[20]; AddressCode: Code[20]; LocationCode: Code[20]);
    var
        ResponseInStr: InStream;
        BlankInstream: InStream;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        inStr: InStream;
        DataExchange: Record "Data Exch.";
        XmlDoc: XmlDocument;
        GetJsonStructure: Codeunit "Get Json Structure";
        DataExchangeDef: Record "Data Exch. Def";
        rootNode: XmlNode;
        NavDataElement: XmlElement;
    begin

        ExecuteWSRequest(Url, ResponseInStr);

        //create data exchange
        DataExchangeDef.Get(DistanceCalcSetupLine."Data Exch. Def. Code");
        IF DataExchangeDef."File Type" = DataExchangeDef."File Type"::Json then begin
            TempBlob.CreateOutStream(OutStr);
            IF NOT GetJsonStructure.JsonToXML(ResponseInStr, OutStr) then
                GetJsonStructure.JsonToXMLCreateDefaultRoot(ResponseInStr, OutStr);
            Clear(ResponseInStr);
            TempBlob.CreateInStream(ResponseInStr); //Json response converted to Xml
        End;

        //add to xml extra needed info: Customer No, Address Code, Location Code, API Setup Line No
        XmlDocument.ReadFrom(ResponseInStr, XmlDoc);
        XmlDoc.SelectSingleNode('//*', rootNode);

        NavDataElement := XmlElement.Create('NavData');
        AddXmlElement(NavDataElement, 'CustomerNo', CustomerNo);
        AddXmlElement(NavDataElement, 'AddressCode', AddressCode);
        AddXmlElement(NavDataElement, 'LocationCode', LocationCode);
        AddXmlElement(NavDataElement, 'APISetupLineCode', DistanceCalcSetupLine."API Code");
        rootNode.AsXmlElement().AddFirst(NavDataElement);

        TempBlob.CreateOutStream(OutStr);
        XmlDoc.WriteTo(OutStr);
        TempBlob.CreateInStream(inStr);

        DataExchange.InsertRec('GoogleMapsDistanceMatrix', inStr, DataExchangeDef.Code);

        CODEUNIT.RUN(DataExchangeDef."Reading/Writing Codeunit", DataExchange);

        //create distance calcutation records using field mapping
        DataExchangeDef.ProcessDataExchange(DataExchange);

    end;

    local procedure ExecuteWSRequest(Url: Text; VAR ResponseInstream: Instream);
    var
        HttpClient: HttpClient;
        Response: HttpResponseMessage;
    begin
        HttpClient.Get(Url, Response);

        If not Response.IsSuccessStatusCode() then
            Error(StrSubstNo('Status code: %1\' +
                'Description: %2',
                Response.HttpStatusCode(),
                Response.ReasonPhrase()));

        Response.Content.ReadAs(ResponseInstream);
    end;

    local procedure AddXmlElement(var ParentElement: XmlElement; NewElementName: Text; NewElementValue: Text);
    var
        newElement: XmlElement;
    begin
        newElement := XmlElement.Create(NewElementName);
        newElement.Add(NewElementValue);
        ParentElement.Add(newElement);
    end;

}