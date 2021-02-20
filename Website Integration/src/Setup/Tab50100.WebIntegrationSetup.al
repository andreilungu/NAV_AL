table 50100 "Web Integration Setup"
{
    Caption = 'Web Integration Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
        }
        field(9; "Website 1 Integration Active"; Boolean)
        {
            Caption = 'Website 1 Integration Active';
            DataClassification = ToBeClassified;
        }
        field(10; "Website 1 API Base URL"; Text[100])
        {
            Caption = 'Website 1 API Base URL';
            DataClassification = ToBeClassified;
        }

        field(20; "Website 1 Create Items"; Text[50])
        {
            Caption = 'Website 1 Create Items EndPoint';
            DataClassification = ToBeClassified;
        }

        field(30; "Log API Requests"; Boolean)
        {
            Caption = 'Log API Requests';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

}
