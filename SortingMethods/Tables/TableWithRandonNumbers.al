table 50100 RandomNumbers
{

    fields
    {
        field(1;PrimaryKey;Integer)
        {
        }

        field(2;RandomNumber;Integer)
        {
        }
    }

    keys
    {
        key(PK;PrimaryKey)
        {
            Clustered = true;
        }
    }
    
    var
        myInt : Integer;

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