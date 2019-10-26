table 50052 "Distance Calculator Setup Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(30; "API Type"; Option)
        {
            OptionMembers = "Google Maps","Bing Maps";
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

    }

    keys
    {
        key(PK; "API Type")
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