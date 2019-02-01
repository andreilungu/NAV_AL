table 50100 StockPrice
{

    fields
    {
        field(1; Symbol; Code[10])
        {
            TableRelation = Stock.Symbol;
        }
        field(2; Date; Date) { }
        field(5; ClosingPrice; Decimal) { }
    }

    keys
    {
        key(PK; Symbol, Date)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

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