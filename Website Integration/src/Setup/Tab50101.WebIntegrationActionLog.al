table 50101 "Web Integration Action Log"
{
    Caption = 'Web Integration Action Log';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
            DataClassification = ToBeClassified;
        }
        field(5; "Table Id"; Integer)
        {
            Caption = 'Table Id';
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = filter('Table'));
        }
        field(6; "Record ID"; RecordId)
        {
            Caption = 'Record ID';
            DataClassification = ToBeClassified;
        }
        field(10; "Action Type"; Enum "Web Integration Action Types")
        {
            Caption = 'Action Type';
            DataClassification = ToBeClassified;
        }

        field(11; "For WebSite"; Enum "For WebSite Enum")
        {
            Caption = 'For Website';
            DataClassification = ToBeClassified;
        }

        field(12; Skip; Boolean)
        {
            Caption = 'Skip';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                IF Skip then
                    Rec.Validate(Processed, TRUE)
                Else
                    Error('');
            end;
        }

        field(15; Processed; Boolean)
        {
            Caption = 'Processed';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                IF Processed THEN begin
                    "Processed At" := CurrentDateTime;
                    "Processed By" := UserId;
                end else begin
                    "Processed At" := 0DT;
                    "Processed By" := '';
                    Skip := False;
                end;
            end;
        }

        field(16; "Processed At"; DateTime)
        {
            Caption = 'Processed At';
            DataClassification = ToBeClassified;
        }
        field(17; "Processed By"; Code[50])
        {
            Caption = 'Processed By';
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";
        }
        field(20; "Web API Log Id"; Integer)
        {
            Caption = 'Web API Log Id';
            DataClassification = ToBeClassified;
            TableRelation = "Web Integration API Log"."Entry No.";
        }
    }
    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }

        key(Key2; Processed, "For WebSite", "Table Id", "Record ID", "Action Type")
        {

        }
    }

    procedure GetNextEntryNo()
    var
        lWebIntAct: Record "Web Integration Action Log";
    begin
        Rec.Id := 1;
        IF lWebIntAct.FindLast() then
            Rec.Id += lWebIntAct.Id;
    end;

    procedure InsertAction(Variant: Variant; ActionType: Enum "Web Integration Action Types"; ForWebsite: Enum "For WebSite Enum")
    var
        RecordRef: RecordRef;
        DataTypeMgt: Codeunit "Data Type Management";
    begin
        IF DataTypeMgt.GetRecordRef(Variant, RecordRef) then begin
            Rec.Init();
            Rec.GetNextEntryNo();
            Rec."Table Id" := RecordRef.Number;
            Rec."Record ID" := RecordRef.RecordId;
            Rec."Action Type" := ActionType;
            Rec."For WebSite" := ForWebsite;
            Rec.Insert(true);
        end;
    end;

}
