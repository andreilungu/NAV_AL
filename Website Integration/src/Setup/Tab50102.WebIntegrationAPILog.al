table 50102 "Web Integration API Log"
{
    Caption = 'Web Integration API Log';
    DataClassification = ToBeClassified;


    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(10; URL; Text[200])
        {
            Caption = 'URL';
            DataClassification = ToBeClassified;
        }
        field(15; Method; Code[10])
        {
            Caption = 'Method';
            DataClassification = ToBeClassified;
        }
        field(20; Request; Blob)
        {
            Caption = 'Request';
            DataClassification = ToBeClassified;
        }
        field(21; Response; Blob)
        {
            Caption = 'Response';
            DataClassification = ToBeClassified;
        }
        field(30; DateTime; DateTime)
        {
            Caption = 'DateTime';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    procedure ReadTextFromBlob(FieldNo: Integer): Text
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
        TempBlob: Codeunit "Temp Blob";
        OStr: OutStream;
        InStr: InStream;
        ReadText: Text;
        tempBlobRec: Record "Web Integration API Log" temporary;
    begin
        RecRef.GETTABLE(Rec);
        FieldRef := RecRef.FIELD(FieldNo);
        FieldRef.CALCFIELD;
        tempBlobRec.Init();
        tempBlobRec.Response := FieldRef.Value;
        IF NOT TempBlobRec.Response.HASVALUE THEN
            EXIT('');

        TempBlobRec.Response.CREATEINSTREAM(InStr);
        InStr.READ(ReadText, MAXSTRLEN(ReadText));
        EXIT(ReadText);
    end;

    procedure InsertLog(pEndpoint: Text; pHttpMethod: Code[10]; pRequest: Text; pResponse: Text)
    var
        OStr: OutStream;
    begin
        Rec.INIT;
        Rec.URL := COPYSTR(pEndPoint, 1, MAXSTRLEN(Rec.URL));
        Rec.DateTime := CURRENTDATETIME;
        Rec.Method := pHttpMethod;
        Rec.INSERT;
        Rec.Request.CREATEOUTSTREAM(OStr);
        OStr.WRITETEXT(pRequest);
        Rec.Response.CREATEOUTSTREAM(OStr);
        OStr.WRITETEXT(pResponse);
        Rec.MODIFY;
        Commit;
    end;

}
