page 50102 Stocks
{
    PageType = List;
    SourceTable = Stock;
    Editable = true;
    CardPageId = 50103;

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
                Image = Import;
                Visible = true;
                Enabled = true;
                trigger OnAction();
                var
                    StockSelectedRecs: Record Stock;
                    HttpStockImport: Codeunit HttpStockDataImportMgt;
                begin
                    CurrPage.SetSelectionFilter(StockSelectedRecs);

                    IF StockSelectedRecs.FindSet() then
                        repeat
                            HttpStockImport.ImportStockData(StockSelectedRecs.Symbol);
                        until StockSelectedRecs.Next() = 0;

                    Message('Import Completed');
                end;
            }
        }

        area(Navigation)
        {
            action(ShowStockPrices)
            {
                ApplicationArea = All;
                RunObject = page StockPriceList;
                RunPageLink = Symbol = FIELD (Symbol);
                Image = ShowList;
                Visible = true;
                Enabled = true;
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