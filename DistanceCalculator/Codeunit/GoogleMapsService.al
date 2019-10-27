codeunit 50000 "Google Maps Service"
{
    trigger OnRun()
    var
        APIKey: Text;
        DistanceCalcSetupLine: Record "Distance Calculator Setup Line";
    begin
        DistanceCalcSetupLine.Get(DistanceCalcSetupLine."API Type"::"Google Maps");
        APIKey := DistanceCalcSetupLine."API Key";
        ImportXML('https://maps.googleapis.com/maps/api/distancematrix/xml?origins=57,+Ion+Heliade Radulescu,+Campina,+Prahova,+Romania&destinations=11,+Episcopul Vulcan,+Bucharest,+Bucharest,+Romania&mode=driving&key=' + APIKey);
    end;

    procedure ImportXML(Url: Text): Text;
    var
        HttpClient: HttpClient;
        Response: HttpResponseMessage;
        ResponseString: Text;
        XmlDoc: XmlDocument;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        XmlStream: InStream;
    begin
        XMLBuffer.DeleteAll();

        HttpClient.Get(Url, Response);

        If not Response.IsSuccessStatusCode() then
            Exit(StrSubstNo('Status code: %1\' +
                'Description: %2',
                Response.HttpStatusCode(),
                Response.ReasonPhrase()));

        Response.Content.ReadAs(ResponseString);
        XmlDocument.ReadFrom(ResponseString, XmlDoc);
        TempBlob.CreateOutStream(OutStr);
        XmlDoc.WriteTo(OutStr);
        TempBlob.CreateInStream(XmlStream);

        XMLBuffer.LoadFromStream(XmlStream);


    end;

    var
        XMLBuffer: Record "XML Buffer";
}