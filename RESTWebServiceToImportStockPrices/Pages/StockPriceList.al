page 50101 StockPriceList
{
    PageType = List;
    SourceTable = StockPrice;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Stocks)
            {
                field(Symbol; Symbol)
                {
                    ApplicationArea = All;
                }
                field(Date; Date)
                {
                    ApplicationArea = All;
                }
                field(ClosingPrice; ClosingPrice)
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