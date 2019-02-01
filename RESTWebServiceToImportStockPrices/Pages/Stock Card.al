page 50103 "Stock Card"
{
    PageType = Card;
    SourceTable = Stock;
    Editable = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Symbol; Symbol)
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ImportStockData)
            {
                ApplicationArea = All;
                RunObject = codeunit HttpStockDataImportMgt;
                Image = Import;
                Visible = true;
                Enabled = true;
                trigger OnAction();
                begin
                end;
            }
        }
    }

    trigger OnOpenPage();
    var
    begin

    end;

    var
        myInt: Integer;


}