table 50050 "Distance Calculator Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
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

        field(20; "Refresh Interval"; Integer)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
            InitValue = 0;
        }

        field(30; "API Type"; Option)
        {
            OptionMembers = "Google Maps","Bing Maps";
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}