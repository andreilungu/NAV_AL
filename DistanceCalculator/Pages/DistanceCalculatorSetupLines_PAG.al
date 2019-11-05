page 50051 "Distance Calc. Setup Lines"
{
    PageType = ListPart;
    SourceTable = 50052;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("API Code"; "API Code")
                {
                    ApplicationArea = All;
                }

                field("API Base URL"; "API Base URL")
                {
                    ApplicationArea = All;
                }

                field("API Key"; "API Key")
                {
                    ApplicationArea = All;
                }
                field(Priority; Priority)
                {
                    ApplicationArea = All;
                    ShowMandatory = True;
                }

                field("Data Exch. Def. Code"; "Data Exch. Def. Code")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
            }
        }
    }
    trigger OnModifyRecord(): Boolean
    var
    begin
        CurrPage.Update(false);
    end;

    trigger OnInsertRecord(Belowxrec: Boolean): Boolean
    var
    begin
        CurrPage.Update(false);
    end;

    trigger OnOpenPage()
    var
    begin
        SetCurrentKey(Priority);
    end;

}