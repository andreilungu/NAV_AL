page 50050 "Distance Calculator Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = 50050;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("API Type"; "API Type")
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

                field("Refresh Interval"; "Refresh Interval")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Refresh Interval (days)';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        Reset();
        If not Get then begin
            Init();
            Insert();
        END;
    end;

    var
        myInt: Integer;
}