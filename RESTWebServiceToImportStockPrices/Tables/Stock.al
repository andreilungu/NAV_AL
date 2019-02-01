table 50101 Stock
{

    fields
    {
        field(1; Symbol; Code[10]) { }
        field(5; Name; Text[250]) { }
        field(7; Description; Text[250]) { }
        field(10; LatestPrice; Decimal)
        {
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(PK; Symbol)
        {
            Clustered = true;
        }
    }

    var

    trigger OnInsert();
    begin
    end;

    trigger OnModify();
    begin
    end;

    trigger OnDelete();
    begin
    end;

    trigger OnRename();
    begin
    end;

}