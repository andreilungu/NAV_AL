table 50052 "Distance Calculator Setup Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "API Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(10; "API Base URL"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(11; "API Key"; Text[150])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = Masked;
        }

        field(20; Priority; Integer)
        {
            DataClassification = ToBeClassified;
            MinValue = 1;
        }

        field(30; "Data Exch. Def. Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Data Exch. Def".Code;
        }

    }

    keys
    {
        key(PK; "API Code")
        {
            Clustered = true;
        }
        key(Priority; Priority)
        {
            Clustered = false;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
        SetCurrentKey(Priority);
    end;

    trigger OnModify()
    begin
        SetCurrentKey(Priority);
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}