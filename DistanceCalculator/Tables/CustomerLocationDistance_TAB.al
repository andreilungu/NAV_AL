table 50051 "Customer Location Distance"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";

        }
        field(2; "Address Code"; Code[10])
        {
            //DEFAULT or Customer Ship-To Address Code
            DataClassification = ToBeClassified;
        }

        field(3; "Location Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
        }

        field(10; "Customer Address"; Text[250])
        {
            DataClassification = ToBeClassified;
        }

        field(20; "Location Address"; Text[250])
        {
            DataClassification = ToBeClassified;
        }

        field(30; "Api Setup Line"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Distance Calculator Setup Line"."API Code";
        }
        field(40; Distance; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(50; Time; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(60; "Last Refresh Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(PK; "Customer No.", "Address Code", "Location Code")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
        "Last Refresh Date" := Today;
    end;

    trigger OnModify()
    begin
        "Last Refresh Date" := Today;
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin
        "Last Refresh Date" := Today;
    end;

}